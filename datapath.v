`timescale 1ns / 1ps

module datapath(
	input clk,
	input reset,
	input [2:0] MemtoReg,
	input MemWrite,
	input [2:0] ALUOp,
	input [2:0] ALUSrc,
	input EXTsign,
	input RegWrite,
	input [2:0] RegDst,
	input [2:0] DMOp,
	input [2:0] NPCOp,
	output [31:0] instr
    );
	 
wire [31:0] npc;
wire [31:0] pc4;
wire [31:0] pc;
wire [31:0] imm32;
wire equal;
wire [4:0] RegAddr;
wire [31:0] RegData;
wire [31:0] Grs;
wire [31:0] Grt;
wire [31:0] ALU_B;
wire [31:0] ALU_result;
wire [31:0] DM_data;

NPC npc1(
	.pc(pc),
	.equal(equal),
	.imm32(imm32),
	.index(instr[25:0]),
	.Grs(Grs),
	.NPCOp(NPCOp),
	.npc(npc),
	.pc4(pc4)
);


PC pc1(
	.clk(clk),
	.reset(reset),
	.npc(npc),
	.pc(pc)
);


IM im1(
	.pc(pc),
	.instr(instr)
);


/////////////////GRF//////////
MUX_8_5 grf_A3_mux(
	.Op(RegDst),
	.data1(instr[20:16]),
	.data2(instr[15:11]),
	.data3(5'b11111),
	.data4(5'b0),
	.out(RegAddr)
);

MUX_8_32 grf_WD_mux(
	.Op(MemtoReg),
	.data1(ALU_result),
	.data2(DM_data),
	.data3(pc4),
	.data4(0),
	.out(RegData)
);

GRF grf1(
	.pc(pc),
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite),
	.A1(instr[25:21]),
	.A2(instr[20:16]),
	.A3(RegAddr),
	.WD(RegData),
	.RD1(Grs),
	.RD2(Grt)
);
	
//////////////DM/////////////
DM dm1(
	.clk(clk),
	.reset(reset),
	.MemWrite(MemWrite),
	.MemAddr(ALU_result),
	.DMOp(DMOp),
	.din(Grt),
	.dout(DM_data),
	.pc(pc)
);
/////////////////EXT///////////////////
EXT ext1(
	.imm16(instr[15:0]),
	.EXTsign(EXTsign),
	.imm32(imm32)
);
///////////////////ALU/////////////////////
MUX_8_32 alu_mux(
	.Op(ALUSrc),
	.data1(Grt),
	.data2(imm32),
	.data3(0),
	.data4(0),
	.out(ALU_B)
);

ALU alu1(
	.A(Grs),
	.B(ALU_B),
	.ALUOp(ALUOp),
	.ALUresult(ALU_result),
	.equal(equal)
);

endmodule
