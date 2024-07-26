`timescale 1ns / 1ps
`include <define.v>

module mips(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
///////////////////////////声明wire区/////////////////////////////

wire [31:0]F_pc,D_pc,E_pc,M_pc,W_pc;
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

////////////////////////////////////连线区//////////////////////////////////

assign i_inst_addr = F_pc;
assign F_instr = i_inst_rdata;


assign m_inst_addr = M_pc;
assign m_data_addr = M_ALU_result;



assign w_grf_we = W_RegWrite;
assign w_grf_addr = W_A3;
assign w_grf_wdata = W_out;
assign w_inst_addr = W_pc;



/////////////////FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF///////////////////////////

PC F_PC(
	.clk(clk),
	.reset(reset),
	.en(!stall),
	.npc(D_npc),
	.pc(F_pc)
);

FD_Reg FD_reg(
	.clk(clk),
	.reset(reset),
	.clear(1'b0),
	.en(!stall),
	.F_pc(F_pc),
	.F_instr(F_instr),
	.D_pc(D_pc),
	.D_instr(D_instr)
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
	.D_Tuse_rt(D_Tuse_rt)
);

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
	.NPCOp(D_NPCOp),
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
	.E_b_judge(E_b_judge)
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
	.RegWrite(E_RegWrite)
);


MD E_MD(
	.clk(clk),
	.reset(reset),
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
	.A(E_ALU_A),
	.B(E_ALU_B),
	.ALUOp(E_ALUOp),
	.ALUresult(E_ALU_result)
);


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
	.M_MD_out(M_MD_out)
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
	.RegWrite(M_RegWrite)
);

BE M_BE(
	.MemAddr(M_ALU_result),
	.din(M_Fw_Grt),
	.BEOp(M_BEOp),
	.m_data_wdata(m_data_wdata),
	.m_data_byteen(m_data_byteen)
);

DE M_DE(
	.MemAddr(M_ALU_result),
	.din(m_data_rdata),
	.DEOp(M_DEOp),
	.dout(M_DM_RD)
);

assign M_out = (M_GRF_WD_Sel == `Reg_pcplus8)?(M_pc+8):
					(M_GRF_WD_Sel == `Reg_ALUresult)?(M_ALU_result):
					(M_GRF_WD_Sel == `Reg_md)?(M_MD_out):	
					(M_GRF_WD_Sel == `Reg_lui)?(M_imm32):
					32'b0;

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
	.W_MD_out(W_MD_out)
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

.stall(stall)

);

endmodule
