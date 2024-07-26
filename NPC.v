`timescale 1ns / 1ps
`include "define.v"
module NPC(
	input [31:0] pc,
	input [31:0] D_pc,
	input [31:0] EPC,
	input Req,
	input D_is_eret,
	input judge,
	input [31:0] imm32,
	input [25:0] index,
	input [31:0] Grs,
	input [2:0] NPCOp,
	output [31:0] npc,
	output [31:0] pc4
    );
assign npc = (Req == 1'b1)? 32'h4180:
					  (D_is_eret == 1'b1)? (EPC + 4) :
					  (NPCOp == `NPC_else) ? (pc+4) :
                 (NPCOp == `NPC_branch && judge == 1'b1) ? (D_pc+4+{imm32[29:0],2'b00}):
					  (NPCOp == `NPC_branch && judge == 1'b0) ? (pc+4):
                 (NPCOp == `NPC_jr_jalr) ? Grs :
                 (NPCOp == `NPC_j_jal) ? {D_pc[31:28],index,2'b00}:
                 (pc+4);
assign pc4 = pc + 4;
endmodule
