`timescale 1ns / 1ps
`include "define.v"
module ctrl(
	input [31:0] instr,
	input  D_b_j,
	
	
	///////////////////////分线/////////////////
	output [4:0] rt,
	output [4:0] rs,
	output [15:0] imm16,
	
	///////////////////////////////////////////
	output MemWrite,
	output [2:0] ALUOp,
	output [2:0] ALU_B_Sel,
	output [2:0] EXTOp,
	output RegWrite,
	output [2:0] RegDst,
	output [2:0] DMOp,
	output [2:0] NPCOp,
	output [2:0] CMPOp,
	output [4:0] GRF_A3,
	output [2:0] GRF_WD_Sel,
	////////////////////////////////////////
   output [2:0] D_Tuse_rs,
   output [2:0] D_Tuse_rt,
	 
   output [2:0] E_Tnew,
   output [2:0] M_Tnew,
   output [2:0] W_Tnew
	
    );
	 
///////////////////////////////分线区/////////////////////////////////////////////////////////////////
wire [5:0] opcode = instr[31:26];
wire [5:0] funcode = instr[5:0];
assign rt = instr[20:16];
assign rs = instr[25:21];
assign imm16 =instr[15:0];

	 
///////////////////////////////判断指令区////////////////////////////////////////////////////////////////

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

///////////////////////////////分类指令区////////////////////////////////////////////////////////////////
wire is_cacR = (is_add || is_sub);
wire is_cacI = (is_ori || is_lui);
wire is_load = (is_lw || is_lb || is_lh);
wire is_store = (is_sw || is_sb || is_sh);


///////////////////////////////控制信号区////////////////////////////////////////////////////////////////
assign CMPOp = (is_beq) ? `CMP_beq :
                   3'b111;
						 
assign RegWrite = (is_cacI || is_load || is_cacR || is_jalr || is_jal)?1:0;					

assign GRF_A3 = (is_cacR || is_jalr )?(instr[15:11]):
					(is_jal)?5'h1f:
					(instr[20:16]);
					

assign GRF_WD_Sel = (is_jal || is_jalr)?`Reg_pcplus8://0
						(is_load)?`Reg_dmrd://1
						(is_lui)?`Reg_lui://3
						`Reg_ALUresult;//4

assign MemWrite = (is_store)?1:0;

assign ALUOp = (is_sub)?`ALU_sub:
					(is_ori)?`ALU_ori:
					(is_lui)?`ALU_lui:
					(is_add || is_load || is_store)?`ALU_add:
					3'b000;
					
assign ALU_B_Sel = (is_cacI || is_load || is_store)?`ALUSrc_imm32:`ALUSrc_Grt;

assign EXTOp = (is_beq || is_load || is_store)?3'b10:
					(is_lui)?3'b1:3'b0;

assign DMOp = (is_lw || is_sw )?`DM_word:
					(is_lh || is_sh )?`DM_halfword:
					(is_lb || is_sb )?`DM_byte:
					`DM_word;

assign NPCOp = (is_beq )?`NPC_branch:
					(is_j || is_jal )?`NPC_j_jal:
					(is_jr || is_jalr )?`NPC_jr_jalr:
					`NPC_else;
					
	
///////////////////////////////计算use now区/////////////////////////////////
	
	
assign D_Tuse_rs = (is_cacR || is_ori || is_load || is_store)?3'b1:
							(is_beq || is_jalr || is_jr)?3'b0:
							3'b100;
assign D_Tuse_rt = (is_store)?3'b10:
						(is_cacR)?3'b1:
						(is_beq)?3'b0:
						3'b100;
						
assign E_Tnew = (is_load)?3'b10:
					(is_cacR || is_ori )?3'b1:3'b0;//////////is_lui 0 is_ori 1
assign M_Tnew = (is_load)?3'b1:3'b0;
assign W_Tnew = 3'b0;


endmodule
