`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
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


wire [2:0] E_ALUOp,E_ALU_B_Sel;

wire M_MemWrite;
wire [2:0] M_DMOp;


wire [31:0] D_Grs,D_Grt,E_Grs,E_Grt,M_Grt;
wire [31:0] E_out,M_out,W_out;
wire [4:0] D_rs,D_rt,E_rs,E_rt,M_rt;





/////////////////FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF///////////////////////////

PC F_PC(
	.clk(clk),
	.reset(reset),
	.en(!stall),
	.npc(D_npc),
	.pc(F_pc)
);

IM F_IM(
	.pc(F_pc),
	.instr(F_instr)	
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
	.GRF_WD_Sel(E_GRF_WD_Sel),
	.GRF_A3(E_A3),
	.ALU_B_Sel(E_ALU_B_Sel),
	.E_Tnew(E_Tnew),
	.RegWrite(E_RegWrite)
);


wire [31:0] E_ALU_B;
MUX_8_32 E_MUX_ALU_B(
	.Op(E_ALU_B_Sel),
	.data1(E_Fw_Grt),
	.data2(E_imm32),
	.out(E_ALU_B)
);

ALU E_ALU(
	.A(E_Fw_Grs),
	.B(E_ALU_B),
	.ALUOp(E_ALUOp),
	.ALUresult(E_ALU_result)
);

MUX_8_32 Eout(
	.Op(E_GRF_WD_Sel),
	.data1(E_pc + 8),
	.data4(E_imm32),
	.out(E_out)
);

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
	.M_pc(M_pc),
	.M_instr(M_instr),
	.M_Grt(M_Grt),
	.M_imm32(M_imm32),
	.M_ALU_result(M_ALU_result),
	.M_b_judge(M_b_judge)
);

//////////////////MMMMMMMMMMMMMMMMMMMMMMMMMMMMM////////////////////
ctrl M_ctrl(
	.instr(M_instr),
	.rt(M_rt),
	.DMOp(M_DMOp),
	.MemWrite(M_MemWrite),
	.GRF_A3(M_A3),
	.GRF_WD_Sel(M_GRF_WD_Sel),
	.M_Tnew(M_Tnew),
	.RegWrite(M_RegWrite)
);


DM M_DM(
	.pc(M_pc),
	.clk(clk),
	.reset(reset),
	.MemWrite(M_MemWrite),
	.MemAddr(M_ALU_result),
	.din(M_Fw_Grt),
	.dout(M_DM_RD),
	.DMOp(M_DMOp)

);

MUX_8_32 Mout(
	.Op(M_GRF_WD_Sel),
	.data1(M_pc + 8),
	.data3(M_ALU_result),
	.data4(M_imm32),
	.out(M_out)
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
	.W_pc(W_pc),
	.W_instr(W_instr),
	.W_imm32(W_imm32),
	.W_ALU_result(W_ALU_result),
	.W_DM_RD(W_DM_RD),
	.W_b_judge(W_b_judge)
);
////////////////WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW/////////////////////////////

ctrl W_ctrl(
	.instr(W_instr),
	.GRF_A3(W_A3),
	.GRF_WD_Sel(W_GRF_WD_Sel),
	.W_Tnew(W_Tnew),
	.RegWrite(W_RegWrite)
);

MUX_8_32 Wout(
	.Op(W_GRF_WD_Sel),
	.data1(W_pc + 8),
	.data2(W_DM_RD),
	.data3(W_ALU_result),
	.data4(W_imm32),
	.out(W_out)
);




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
