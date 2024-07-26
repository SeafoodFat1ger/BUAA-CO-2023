`timescale 1ns / 1ps
`include "define.v"
module NPC(
	input [31:0] pc,
	input equal,
	input [31:0] imm32,
	input [25:0] index,
	input [31:0] Grs,
	input [2:0] NPCOp,
	output [31:0] npc,
	output [31:0] pc4
    );
assign npc = (NPCOp == `NPC_else) ? (pc+4) :
                 (NPCOp == `NPC_beq && equal == 1) ? (pc+4+{imm32[29:0],2'b00}):
					  (NPCOp == `NPC_beq && equal == 0) ? (pc+4):
                 (NPCOp == `NPC_jr_jalr) ? Grs :
                 (NPCOp == `NPC_j_jal) ? {pc[31:28],index,2'b00}:
                 (pc+4);
assign pc4 = pc + 4;
endmodule
