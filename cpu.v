`timescale 1ns / 1ps
`include <define.v>

module cpu(
    input clk,
    input reset,
	 input [5:0] HWInt,
	 input [31:0] CPU_inst_rdata,
	 input [31:0] CPU_DM_rdata,
	 
	 
	 output [31:0] CPU_inst_addr,
	 output [31:0] CPU_DM_addr,
	 output [31:0] CPU_DM_wdata,
	 output [3:0] CPU_DM_byteen,
	 output [31:0] PC_M,
	
	 
	 output CPU_w_grf_we,
    output [4:0] CPU_w_grf_addr,
    output [31:0] CPU_w_grf_wdata,
	 output [31:0] PC_W,
	 output [31:0] PC_macro
);

///////////////////////////声明wire区/////////////////////////////
wire Req;
wire [31:0]F_pc,D_pc,E_pc,M_pc,W_pc;
wire [31:0]F_tmp_pc;
wire [31:0]F_instr,D_instr,E_instr,M_instr,W_instr;
wire [31:0]D_npc;
wire stall;

wire D_RegWrite,E_RegWrite,M_RegWrite,W_RegWrite;

wire [4:0] D_A3,E_A3,M_A3,W_A3;
wire [2:0] D_GRF_WD_Sel,E_GRF_WD_Sel,M_GRF_WD_Sel,W_GRF_WD_Sel;

wire [31:0]D_Fw_Grs,D_Fw_Grt,E_Fw_Grs,E_Fw_Grt,M_Fw_Grt;

wire [31:0] D_imm32,E_imm32,M_imm32,W_imm32;
wire [31:0] E_ALU_result,M_ALU_result,W_ALU_result;
wire [31:0]M_DM_RD,W_DM_RD;


wire [2:0] D_Tnew,E_Tnew,M_Tnew,W_Tnew;
wire [2:0] D_Tuse_rs,D_Tuse_rt;


wire [2:0] D_EXTOp;
wire D_b_judge,E_b_judge,M_b_judge,W_b_judge;
wire [2:0] D_CMPOp,D_NPCOp;
wire [15:0] D_imm16;
wire D_isMDFT;

wire [3:0] E_ALUOp;
wire [2:0] E_ALU_A_Sel,E_ALU_B_Sel;
wire [31:0] E_ALU_A;
wire [31:0] E_ALU_B;
wire [31:0] E_MD_HI,E_MD_LO;
wire E_MD_start,E_MD_busy;
wire [3:0] E_MDOp;


wire M_MemWrite;
wire [2:0] M_BEOp,M_DEOp;

wire [31:0] E_MD_out,M_MD_out,W_MD_out;
wire [31:0] D_Grs,D_Grt,E_Grs,E_Grt,M_Grt;
wire [31:0] E_out,M_out,W_out;
wire [4:0] D_rs,D_rt,E_rs,E_rt,M_rt;

//--------------P7--------------------//

wire F_Exc_AdEL;
wire D_is_eret,D_Exc_syscall,D_Exc_RI;
wire M_is_eret;
wire [31:0] EPC;

wire [4:0] E_rd,M_rd;
wire M_CP0_WE,M_is_mtc0,E_is_mtc0;
wire [31:0] M_CP0_out,W_CP0_out;



wire E_is_Ov,E_is_load,E_is_store;
wire E_Exc_Ov,E_Exc_Ovload,E_Exc_Ovstore;
wire M_Exc_Ovload,M_Exc_Ovstore;
wire M_Exc_AdES,M_Exc_AdEL;
wire F_BD,D_BD,E_BD,M_BD;



wire [4:0] F_ExcCode,D_ExcCode,E_ExcCode,M_ExcCode;
wire [4:0] D_tmp_ExcCode,E_tmp_ExcCode,M_tmp_ExcCode;

////////////////////////////////////连线区//////////////////////////////////

assign CPU_DM_addr = M_ALU_result;



assign CPU_w_grf_we = W_RegWrite;
assign CPU_w_grf_addr = W_A3;
assign CPU_w_grf_wdata = W_out;
assign PC_W = W_pc;

assign PC_M = M_pc;
assign PC_macro = M_pc;

/////////////////FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF///////////////////////////

PC F_PC(
	.clk(clk),
	.reset(reset),
	.Req(Req),
	.en(!stall),
	.npc(D_npc),
	.pc(F_tmp_pc)
);


assign F_pc = D_is_eret? EPC :F_tmp_pc;

assign F_Exc_AdEL = (! D_is_eret)&&((F_pc[1:0] != 2'b00)||(F_pc < 32'h3000)||(F_pc > 32'h6ffc));
assign CPU_inst_addr = F_pc; 
assign F_instr = (F_Exc_AdEL) ? 32'd0 :CPU_inst_rdata;

assign F_ExcCode = (F_Exc_AdEL) ? `EXC_AdEL : `EXC_else;

assign F_BD = (D_NPCOp != `NPC_else);

FD_Reg FD_reg(
	.clk(clk),
	.reset(reset),
	.clear(1'b0),
	.en(!stall),
	.F_pc(F_pc),
	.F_instr(F_instr),
	.D_pc(D_pc),
	.D_instr(D_instr),
	
	.Req(Req),
	.F_BD(F_BD),
	.D_BD(D_BD),
	.F_ExcCode(F_ExcCode),
	.D_ExcCode(D_tmp_ExcCode)
);

///////////////////////DDDDDDDDDDDDDDDDDDDDDDDD////////////////////////


ctrl D_ctrl(
	.instr(D_instr),
	.rs(D_rs),
	.rt(D_rt),
	.imm16(D_imm16),
	.CMPOp(D_CMPOp),
	.EXTOp(D_EXTOp),
	.NPCOp(D_NPCOp),
	.isMDFT(D_isMDFT),
	.RegWrite(D_RegWrite),
	.D_Tuse_rs(D_Tuse_rs),
	.D_Tuse_rt(D_Tuse_rt),
	
	//--------P7--------//
	
	.D_is_eret(D_is_eret),
	.D_Exc_syscall(D_Exc_syscall),
	.D_Exc_RI(D_Exc_RI)
	
);

assign D_ExcCode = (D_tmp_ExcCode != `EXC_else)? D_tmp_ExcCode:
						(D_Exc_syscall)? `EXC_syscall:
						(D_Exc_RI)? `EXC_RI:
						`EXC_else;

CMP D_CMP(
	.CMPOp(D_CMPOp),
	.A(D_Fw_Grs),
	.B(D_Fw_Grt),
	.CMP_result(D_b_judge)
);


//assign RegWrite = (W_RegWrite && (!W_is_this || W_b_j)); 跳转写建议加入ctrl
GRF D_GRF(
	.clk(clk),
	.reset(reset),
	.pc(W_pc),
	.A1(D_rs),
	.A2(D_rt),
	.A3(W_A3),
	.WD(W_out),
	.RegWrite(W_RegWrite),
	.RD1(D_Grs),
	.RD2(D_Grt)	
);


EXT D_EXT(
	.imm16(D_imm16),
	.imm32(D_imm32),
	.EXTsign(D_EXTOp)
);


NPC D_NPC(
	.D_pc(D_pc),
	.Req(Req),
	.NPCOp(D_NPCOp),
	.EPC(EPC),
	.D_is_eret(D_is_eret),
	.pc(F_pc),
	.judge(D_b_judge),
	.imm32(D_imm32),
	.index(D_instr[25:0]),
	.Grs(D_Fw_Grs),
	.npc(D_npc)
);

DE_Reg DE_Reg(
	.clk(clk),
	.reset(reset),
	.clear(stall),
	.en(1'b1),
	.D_pc(D_pc),
	.D_instr(D_instr),
	.D_Grs(D_Fw_Grs),
	.D_Grt(D_Fw_Grt),
	.D_imm32(D_imm32),
	.D_b_judge(D_b_judge),
	.E_pc(E_pc),
	.E_instr(E_instr),
	.E_Grs(E_Grs),
	.E_Grt(E_Grt),
	.E_imm32(E_imm32),
	.E_b_judge(E_b_judge),
	
	.Req(Req),
	.stall(stall),
	.E_BD(E_BD),
	.D_BD(D_BD),
	.D_ExcCode(D_ExcCode),
	.E_ExcCode(E_tmp_ExcCode)
);

///////////////////EEEEEEEEEEEEEEEEEEEEEE///////////////////////////
ctrl E_ctrl(
	.instr(E_instr),
	.rs(E_rs),
	.rt(E_rt),
	.ALUOp(E_ALUOp),
	.MDOp(E_MDOp),
	.MD_start(E_MD_start),
	.GRF_WD_Sel(E_GRF_WD_Sel),
	.GRF_A3(E_A3),
	.ALU_A_Sel(E_ALU_A_Sel),
	.ALU_B_Sel(E_ALU_B_Sel),
	.E_Tnew(E_Tnew),
	.RegWrite(E_RegWrite),
	.E_is_load(E_is_load),
	.E_is_store(E_is_store),
	.E_is_Ov(E_is_Ov),
	.rd(E_rd),
	.E_is_mtc0(E_is_mtc0)
);


MD E_MD(
	.clk(clk),
	.reset(reset),
	.Req(Req),
	.start(E_MD_start),
	.MDOp(E_MDOp),
	.A(E_Fw_Grs),
	.B(E_Fw_Grt),
	.HI(E_MD_HI),
	.LO(E_MD_LO),
	.out(E_MD_out),
	.busy(E_MD_busy)
);


assign E_ALU_B = (E_ALU_B_Sel == `ALU_B_imm32)?E_imm32:
					(E_ALU_B_Sel == `ALU_B_shamt)?{{27{1'b0}},E_instr[10:6]}:
					(E_ALU_B_Sel == `ALU_B_Grs)?E_Fw_Grs:
					(E_ALU_B_Sel == `ALU_B_Grt)?E_Fw_Grt:
					E_Fw_Grt;
					
assign E_ALU_A = (E_ALU_A_Sel == `ALU_A_Grt)?E_Fw_Grt:
						(E_ALU_A_Sel == `ALU_A_Grs)?E_Fw_Grs:
						E_Fw_Grs;

ALU E_ALU(
	.E_is_Ov(E_is_Ov),
	.E_is_load(E_is_load),
	.E_is_store(E_is_store),
	.A(E_ALU_A),
	.B(E_ALU_B),
	.ALUOp(E_ALUOp),
	.ALUresult(E_ALU_result),
	.E_Exc_Ov(E_Exc_Ov),
	.E_Exc_Ovload(E_Exc_Ovload),
	.E_Exc_Ovstore(E_Exc_Ovstore)
);

assign E_ExcCode = (E_tmp_ExcCode != `EXC_else)? E_tmp_ExcCode:
						(E_Exc_Ov)? `EXC_Ov:
						`EXC_else;

assign E_out = (E_GRF_WD_Sel == `Reg_pcplus8)?(E_pc+8):
					(E_GRF_WD_Sel == `Reg_lui)?(E_imm32):
					32'b0;

EM_Reg EM_Reg(
	.clk(clk),
	.reset(reset),
	.clear(1'b0),
	.en(1'b1),
	.E_pc(E_pc),
	.E_instr(E_instr),
	.E_Grt(E_Fw_Grt),
	.E_imm32(E_imm32),
	.E_ALU_result(E_ALU_result),
	.E_b_judge(E_b_judge),
	.E_MD_out(E_MD_out),
	.M_pc(M_pc),
	.M_instr(M_instr),
	.M_Grt(M_Grt),
	.M_imm32(M_imm32),
	.M_ALU_result(M_ALU_result),
	.M_b_judge(M_b_judge),
	.M_MD_out(M_MD_out),
	
	.E_Exc_Ovload(E_Exc_Ovload),
	.E_Exc_Ovstore(E_Exc_Ovstore),
	.M_Exc_Ovload(M_Exc_Ovload),
	.M_Exc_Ovstore(M_Exc_Ovstore),
	
	.Req(Req),
	.E_BD(E_BD),
	.M_BD(M_BD),
	.E_ExcCode(E_ExcCode),
	.M_ExcCode(M_tmp_ExcCode)
	
);


//////////////////MMMMMMMMMMMMMMMMMMMMMMMMMMMMM////////////////////
ctrl M_ctrl(
	.instr(M_instr),
	.rt(M_rt),
	.BEOp(M_BEOp),
	.DEOp(M_DEOp),
	.MemWrite(M_MemWrite),
	.GRF_A3(M_A3),
	.GRF_WD_Sel(M_GRF_WD_Sel),
	.M_Tnew(M_Tnew),
	.RegWrite(M_RegWrite),
	
	.rd(M_rd),
	.M_is_eret(M_is_eret),
	.M_is_mtc0(M_is_mtc0),
	.M_CP0_WE(M_CP0_WE)
);

BE M_BE(
	.MemAddr(M_ALU_result),
	.Req(Req),
	.M_Exc_Ovstore(M_Exc_Ovstore),
	.din(M_Fw_Grt),
	.BEOp(M_BEOp),
	.m_data_wdata(CPU_DM_wdata),
	.m_data_byteen(CPU_DM_byteen),
	.M_Exc_AdES(M_Exc_AdES)

);

DE M_DE(
	.MemAddr(M_ALU_result),
	.M_Exc_Ovload(M_Exc_Ovload),
	.din(CPU_DM_rdata),
	.DEOp(M_DEOp),
	.dout(M_DM_RD),
	.M_Exc_AdEL(M_Exc_AdEL)
	
);

assign M_ExcCode = (M_tmp_ExcCode != `EXC_else)? M_tmp_ExcCode:
						(M_Exc_AdES)? `EXC_AdES:
						(M_Exc_AdEL)? `EXC_AdEL:
						`EXC_else;

assign M_out = (M_GRF_WD_Sel == `Reg_pcplus8)?(M_pc+8):
					(M_GRF_WD_Sel == `Reg_ALUresult)?(M_ALU_result):
					(M_GRF_WD_Sel == `Reg_md)?(M_MD_out):	
					(M_GRF_WD_Sel == `Reg_lui)?(M_imm32):
					32'b0;


CP0 M_CP0(
	.clk(clk),
	.reset(reset),
	.A1(M_rd),
	.A2(M_rd),
	.BD(M_BD),
	.Din(M_Fw_Grt),
	.PC(M_pc),
	.ExcCodeIn(M_ExcCode),
	.HWInt(HWInt),
	.WE(M_CP0_WE),
	.EXLClr(M_is_eret),
	.Req(Req),
	.EPCOut(EPC),
	.Dout(M_CP0_out)

);



MW_Reg MW_Reg(
	.clk(clk),
	.reset(reset),
	.clear(1'b0),
	.en(1'b1),
	.M_pc(M_pc),
	.M_imm32(M_imm32),
	.M_instr(M_instr),
	.M_ALU_result(M_ALU_result),
	.M_DM_RD(M_DM_RD),
	.M_b_judge(M_b_judge),
	.M_MD_out(M_MD_out),
	.W_pc(W_pc),
	.W_instr(W_instr),
	.W_imm32(W_imm32),
	.W_ALU_result(W_ALU_result),
	.W_DM_RD(W_DM_RD),
	.W_b_judge(W_b_judge),
	.W_MD_out(W_MD_out),
	.M_CP0_out(M_CP0_out),
	.W_CP0_out(W_CP0_out),
	.Req(Req)
);
////////////////WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW/////////////////////////////

ctrl W_ctrl(
	.instr(W_instr),
	.GRF_A3(W_A3),
	.GRF_WD_Sel(W_GRF_WD_Sel),
	.W_Tnew(W_Tnew),
	.RegWrite(W_RegWrite)
);


assign W_out = (W_GRF_WD_Sel == `Reg_pcplus8)?(W_pc+8):
					(W_GRF_WD_Sel == `Reg_dmrd)?(W_DM_RD):
					(W_GRF_WD_Sel == `Reg_ALUresult)?(W_ALU_result):
					(W_GRF_WD_Sel == `Reg_lui)?(W_imm32):
					(W_GRF_WD_Sel == `Reg_md)?(W_MD_out):	
					(W_GRF_WD_Sel == `Reg_CP0)?(W_CP0_out):	
					32'b0;


////////////////////////////hazard////////////////////////////////////


Harzad harzad(
.D_Grs(D_Grs),
.D_Grt(D_Grt),
.E_Grs(E_Grs),
.E_Grt(E_Grt),
.M_Grt(M_Grt),

.D_rs(D_rs),
.D_rt(D_rt),
.E_rs(E_rs),
.E_rt(E_rt),
.M_rt(M_rt),

.E_A3(E_A3),
.M_A3(M_A3),
.W_A3(W_A3),

.D_Tuse_rs(D_Tuse_rs),
.D_Tuse_rt(D_Tuse_rt),
.E_Tnew(E_Tnew),
.M_Tnew(M_Tnew),
.W_Tnew(W_Tnew),

.E_out(E_out),
.M_out(M_out),
.W_out(W_out),

	 
.D_isMDFT(D_isMDFT),
.E_MD_busy(E_MD_busy),
.E_MD_start(E_MD_start),


.E_RegWrite(E_RegWrite),
.M_RegWrite(M_RegWrite),
.W_RegWrite(W_RegWrite),

.D_Fw_Grs(D_Fw_Grs),
.D_Fw_Grt(D_Fw_Grt),
.E_Fw_Grs(E_Fw_Grs),
.E_Fw_Grt(E_Fw_Grt),
.M_Fw_Grt(M_Fw_Grt),



.D_is_eret(D_is_eret),
.E_is_mtc0(E_is_mtc0),
.M_is_mtc0(M_is_mtc0),
.E_rd(E_rd),
.M_rd(M_rd),



.stall(stall)

);

endmodule
