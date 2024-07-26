`timescale 1ns / 1ps
`include "define.v"
module ctrl(
	input [31:0] instr,
	output [2:0] MemtoReg,
	output MemWrite,
	output [2:0] ALUOp,
	output [2:0] ALUSrc,
	output EXTsign,
	output RegWrite,
	output [2:0] RegDst,
	output [2:0] DMOp,
	output [2:0] NPCOp
    );
wire [5:0] opcode = instr[31:26];
wire [5:0] funcode = instr[5:0];
wire is_add = (opcode == `opcode_add && funcode == `funcode_add);
wire is_sub = (opcode == `opcode_sub && funcode == `funcode_sub);
wire is_ori = (opcode == `opcode_ori);
wire is_lw= (opcode == `opcode_lw);
wire is_sw = (opcode == `opcode_sw);
wire is_beq = (opcode == `opcode_beq);
wire is_lui = (opcode == `opcode_lui);
wire is_jal = (opcode == `opcode_jal);
wire is_jalr = (opcode == `opcode_jalr && funcode == `funcode_jalr);
wire is_jr = (opcode == `opcode_jr && funcode == `funcode_jr);
wire is_j = (opcode == `opcode_j);
wire is_lb = (opcode == `opcode_lb);
wire is_lh = (opcode == `opcode_lh);
wire is_sb = (opcode == `opcode_sb);
wire is_sh = (opcode == `opcode_sh);
/////控制信号每种取值所对应的指令////
assign MemtoReg = (is_lw || is_lb || is_lh)?`Reg_rd:
						(is_jal || is_jalr)?`Reg_pcplus4:
						`Reg_ALUresult;

assign MemWrite = (is_sw || is_sb || is_sh)?1:0;

assign ALUOp = (is_sub)?`ALU_sub:
					(is_ori)?`ALU_ori:
					(is_lui)?`ALU_lui:
					(is_add || is_lw || is_lb || is_lh || is_sw || is_sb || is_sh)?`ALU_add:
					3'b000;
					
assign ALUSrc = (is_ori || is_lui || is_lw || is_lb || is_lh || is_sw || is_sb || is_sh)?`ALUSrc_imm32:`ALUSrc_Grt;

assign EXTsign = (is_beq || is_lw || is_lb || is_lh || is_sw || is_sb || is_sh)?1:0;

assign RegWrite = (is_ori || is_lui || is_lw || is_lb || is_lh || is_add || is_sub || is_jalr || is_jal)?1:0;

assign RegDst = ( is_add || is_sub || is_jalr )?`RegDst_rd:
					(is_jal)?`RegDst_31:
					`RegDst_rt;
					
assign DMOp = (is_lw || is_sw )?`DM_word:
					(is_lh || is_sh )?`DM_halfword:
					(is_lb || is_sb )?`DM_byte:
					`DM_word;

assign NPCOp = (is_beq )?`NPC_beq:
					(is_j || is_jal )?`NPC_j_jal:
					(is_jr || is_jalr )?`NPC_jr_jalr:
					`NPC_else;


endmodule
