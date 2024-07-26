`timescale 1ns / 1ps
`include "define.v"
module ctrl(
	input [31:0] instr,
	input  D_b_j,
	
	
	///////////////////////分线/////////////////
	output [4:0] rt,
	output [4:0] rs,
	output [4:0] rd,
	output [15:0] imm16,
	
	///////////////////////////////////////////
	output MemWrite,
	output [3:0] ALUOp,
	output [2:0] ALU_A_Sel,
	output [2:0] ALU_B_Sel,
	output [2:0] EXTOp,
	output RegWrite,
	output [2:0] RegDst,
	output [2:0] BEOp,
	output [2:0] DEOp,
	output [2:0] NPCOp,
	output [2:0] CMPOp,
	output [4:0] GRF_A3,
	output [2:0] GRF_WD_Sel,
	
	output [3:0] MDOp,
	output MD_start,
	output isMDFT,
	
	////////////////////////////////////////
   output [2:0] D_Tuse_rs,
   output [2:0] D_Tuse_rt,
	 
   output [2:0] E_Tnew,
   output [2:0] M_Tnew,
   output [2:0] W_Tnew,
	
	
	//---------------------P7---------------------//
	output D_Exc_RI,
	output D_is_eret,
	output D_Exc_syscall,
	
	output E_is_Ov,
	output E_is_load,
	output E_is_store,

	output M_is_eret,
	output M_CP0_WE,
	output M_is_mtc0,
	output E_is_mtc0
    );
	 
///////////////////////////////分线区/////////////////////////////////////////////////////////////////
wire [5:0] opcode = instr[31:26];
wire [5:0] funcode = instr[5:0];
assign rt = instr[20:16];
assign rs = instr[25:21];
assign rd = instr[15:11];
assign imm16 =instr[15:0];

	 
///////////////////////////////判断指令区////////////////////////////////////////////////////////////////

//---------------------P7---------------------//

wire is_syscall = (opcode == `opcode_syscall && funcode == `funcode_syscall);
wire is_mtc0 = (opcode == `opcode_mtc0 && rs == `rscode_mtc0);
wire is_mfc0 = (opcode == `opcode_mfc0 && rs == `rscode_mfc0);
wire is_eret = (instr == 32'b01000010000000000000000000011000);

//cacR//////////////////////////
wire is_add = (opcode == `opcode_add && funcode == `funcode_add);
wire is_sub = (opcode == `opcode_sub && funcode == `funcode_sub);
wire is_and = (opcode == `opcode_and && funcode == `funcode_and);
wire is_or = (opcode == `opcode_or && funcode == `funcode_or);
wire is_slt = (opcode == `opcode_slt && funcode == `funcode_slt);
wire is_sltu = (opcode == `opcode_sltu && funcode == `funcode_sltu);
wire is_sll = (opcode == `opcode_sll && funcode == `funcode_sll);
wire is_sllv = (opcode == `opcode_sllv && funcode == `funcode_sllv);
wire is_addu = (opcode == `opcode_addu && funcode == `funcode_addu);
wire is_subu = (opcode == `opcode_subu && funcode == `funcode_subu);

//cacI//////////////////////////
wire is_ori = (opcode == `opcode_ori);
wire is_addi = (opcode == `opcode_addi);
wire is_andi = (opcode == `opcode_andi);
wire is_addiu = (opcode == `opcode_addiu);

//lui//////////////////////////
wire is_lui = (opcode == `opcode_lui);

//branch//////////////////////////
wire is_beq = (opcode == `opcode_beq);
wire is_bne = (opcode == `opcode_bne);

//jjjjj//////////////////////////
wire is_jal = (opcode == `opcode_jal);
wire is_jalr = (opcode == `opcode_jalr && funcode == `funcode_jalr);
wire is_jr = (opcode == `opcode_jr && funcode == `funcode_jr);
wire is_j = (opcode == `opcode_j);


//l&s//////////////////////////
wire is_lw= (opcode == `opcode_lw);
wire is_sw = (opcode == `opcode_sw);
wire is_lb = (opcode == `opcode_lb);
wire is_lh = (opcode == `opcode_lh);
wire is_sb = (opcode == `opcode_sb);
wire is_sh = (opcode == `opcode_sh);

//Mdft//////////////////////////
wire is_mult = (opcode == `opcode_mult && funcode == `funcode_mult);
wire is_multu = (opcode == `opcode_multu && funcode == `funcode_multu);
wire is_div = (opcode == `opcode_div && funcode == `funcode_div);
wire is_divu = (opcode == `opcode_divu && funcode == `funcode_divu);
wire is_mthi = (opcode == `opcode_mthi && funcode == `funcode_mthi);
wire is_mtlo = (opcode == `opcode_mtlo && funcode == `funcode_mtlo);
wire is_mfhi = (opcode == `opcode_mfhi && funcode == `funcode_mfhi);
wire is_mflo = (opcode == `opcode_mflo && funcode == `funcode_mflo);

///////////////////////////////分类指令区////////////////////////////////////////////////////////////////
wire is_cacR = (is_addu||is_subu||is_add || is_sub || is_slt||is_sltu || is_and || is_or || is_slt || is_sltu );
//|| is_sll || is_sllv
wire is_cacI = (is_addiu||is_andi || is_addi || is_ori || is_lui);
wire is_load = (is_lw || is_lb || is_lh);
wire is_store = (is_sw || is_sb || is_sh);	
wire is_shift_s = is_sll;
wire is_shift_v = is_sllv;
wire is_md = (is_mult||is_multu||is_div||is_divu);
wire is_mf = (is_mfhi||is_mflo);
wire is_mt = (is_mthi||is_mtlo);
wire is_branch = (is_beq||is_bne);

///////////////////////////////控制信号区////////////////////////////////////////////////////////////////

assign D_Exc_syscall = is_syscall;

assign D_Exc_RI =!(is_cacR || is_cacI || is_load || is_store ||
						is_md || is_mt || is_mf ||
						is_branch || is_jal || is_jr || 			
						is_mtc0 || is_mfc0 || is_syscall || is_eret
						|| (instr == 32'd0)
						);									// is_jalr || is_j 
assign D_is_eret = is_eret;
assign M_is_eret = is_eret;

assign E_is_load = is_load;
assign E_is_store = is_store;
assign E_is_Ov = is_add||is_sub||is_addi;

assign M_CP0_WE = is_mtc0;

assign M_is_mtc0 = is_mtc0;
assign E_is_mtc0 = is_mtc0;

/////////////////////////////////////////////////////////

assign CMPOp = (is_beq) ? `CMP_beq :
					(is_bne) ? `CMP_bne :
                   3'b111;
						 
assign RegWrite = (is_mfc0||is_cacI || is_load || is_cacR || is_jalr || is_jal || is_mf )?1:0;					

assign GRF_A3 = (is_cacR || is_jalr || is_mf)?(instr[15:11]): //rd
					(is_jal)?5'h1f:
					(is_cacI ||is_lui||is_load || is_mfc0)?(instr[20:16]): //rt
					5'b0;
					
assign GRF_WD_Sel = (is_jal || is_jalr)?`Reg_pcplus8:
						(is_load)?`Reg_dmrd:
						(is_mf)?`Reg_md:
						(is_lui)?`Reg_lui:
						(is_mfc0)?`Reg_CP0:
						`Reg_ALUresult;

assign MemWrite = (is_store)?1:0;

assign ALUOp = (is_sub||is_subu)?`ALU_sub:
					(is_ori || is_or)?`ALU_or:
					(is_lui)?`ALU_lui:
					(is_and || is_andi)?`ALU_and:
					(is_slt)?`ALU_slt:
					(is_sltu)?`ALU_sltu:
					(is_sll)?`ALU_sltu:
					(is_sltu)?`ALU_sltu:
					(is_sll || is_sllv)?`ALU_left:	
					`ALU_add;
					
					
assign ALU_A_Sel = (is_shift_s||is_shift_v)?`ALU_A_Grt:`ALU_A_Grs;				
assign ALU_B_Sel = (is_cacI || is_load || is_store)?`ALU_B_imm32:
						(is_shift_s)?`ALU_B_shamt:
						(is_shift_v)?`ALU_B_Grs:
						`ALU_B_Grt;

assign EXTOp = (is_branch || is_load || is_store || (is_cacI && !is_lui && !is_andi && !is_ori))?3'b10:
					(is_lui )?3'b1:3'b0;
					
assign BEOp = (is_sw )?`BE_word:
					(is_sh )?`BE_halfword:
					(is_sb )?`BE_byte:
					3'b111;	


assign DEOp = (is_lw )?`DE_word:
					(is_lh )?`DE_halfword:
					(is_lb )?`DE_byte:
					3'b111;	
					

assign NPCOp = (is_branch )?`NPC_branch:
					(is_j || is_jal )?`NPC_j_jal:
					(is_jr || is_jalr )?`NPC_jr_jalr:
					`NPC_else;
					
assign MDOp = (is_mult)?`MD_mult:
					(is_multu)?`MD_multu:
					(is_div)?`MD_div:
					(is_divu)?`MD_divu:
					(is_mfhi)?`MD_mfhi:
					(is_mflo)?`MD_mflo:
					(is_mthi)?`MD_mthi:
					(is_mtlo)?`MD_mtlo:`MD_else;


assign MD_start = (is_md);
assign isMDFT = (is_md||is_mf||is_mt);

	
///////////////////////////////计算use now区/////////////////////////////////

assign D_Tuse_rs = (is_md||is_mt||(is_cacR && !is_shift_s) || (is_cacI && ! is_lui) || is_load || is_store)?3'b1:
							(is_branch || is_jalr || is_jr)?3'b0:
							3'b100;
assign D_Tuse_rt = (is_store || is_mtc0)?3'b10:
						(is_md||is_cacR)?3'b1:
						(is_branch)?3'b0:
						3'b100;
						
assign E_Tnew = (is_load || is_mfc0 )?3'b10:
					(is_cacR || (is_cacI && ! is_lui)||is_mf )?3'b1:3'b0;//////////is_lui 0 is_ori 1
assign M_Tnew = (is_load || is_mfc0 )?3'b1:3'b0;
assign W_Tnew = 3'b0;


endmodule
