`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
);
wire [31:0] instr;
wire [2:0] MemtoReg;
wire MemWrite;
wire [2:0] ALUOp;
wire [2:0] ALUSrc;
wire EXTsign;
wire RegWrite;
wire [2:0] RegDst;
wire [2:0] DMOp;
wire [2:0] NPCOp;
ctrl c1(
	.instr(instr),
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUOp(ALUOp),
	.ALUSrc(ALUSrc),
	.EXTsign(EXTsign),
	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.DMOp(DMOp),
	.NPCOp(NPCOp)
);
datapath d1(
	.clk(clk),
	.reset(reset),
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUOp(ALUOp),
	.ALUSrc(ALUSrc),
	.EXTsign(EXTsign),
	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.DMOp(DMOp),
	.NPCOp(NPCOp),
	.instr(instr)
);
endmodule
