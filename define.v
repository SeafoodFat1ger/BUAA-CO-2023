///////////opcode////////////
//////ºÏ≤È”–Œﬁ≥ÂÕª/////
`define opcode_add 6'b000000
`define opcode_sub 6'b000000
`define opcode_and 6'b000000
`define opcode_or 6'b000000
`define opcode_slt 6'b000000
`define opcode_sltu 6'b000000
`define opcode_sll 6'b000000
`define opcode_sllv 6'b000000

`define opcode_beq 6'b000100
`define opcode_bne 6'b000101

`define opcode_lui 6'b001111

`define opcode_jal 6'b000011
`define opcode_jr 6'b000000
`define opcode_jalr 6'b000000
`define opcode_j 6'b000010

`define opcode_lw 6'b100011
`define opcode_sw 6'b101011
`define opcode_lb 6'b100000
`define opcode_lh 6'b100001
`define opcode_sb 6'b101000
`define opcode_sh 6'b101001



`define opcode_addi 6'b001000
`define opcode_andi 6'b001100
`define opcode_ori 6'b001101

`define opcode_mult 6'b000000
`define opcode_multu 6'b000000
`define opcode_div 6'b000000
`define opcode_divu 6'b000000
`define opcode_mthi 6'b000000
`define opcode_mtlo 6'b000000
`define opcode_mfhi 6'b000000
`define opcode_mflo 6'b000000



///////////funcode//////////////
`define funcode_add 6'b100000
`define funcode_sub 6'b100010
`define funcode_jr 6'b001000
`define funcode_jalr 6'b001001
`define funcode_sll 6'b000000
`define funcode_sllv 6'b000100
`define funcode_and 6'b100100
`define funcode_or 6'b100101
`define funcode_slt 6'b101010
`define funcode_sltu 6'b101011

`define funcode_mult 6'b011000
`define funcode_multu 6'b011001
`define funcode_div 6'b011010
`define funcode_divu 6'b011011
`define funcode_mthi 6'b010001
`define funcode_mtlo 6'b010011
`define funcode_mfhi 6'b010000
`define funcode_mflo 6'b010010

////////////GRF_WD_Sel///////////
`define Reg_pcplus8 3'b000
`define Reg_dmrd 3'b001
`define Reg_ALUresult 3'b010
`define Reg_lui 3'b011
`define Reg_md 3'b100

///////////ALUOp//////////////
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_or 4'b0010
`define ALU_lui 4'b0011
`define ALU_and 4'b0100
`define ALU_slt 4'b0101
`define ALU_sltu 4'b0110
`define ALU_left  4'b0111
`define ALU_right  4'b1000
`define ALU_right_logic  4'b1001

///////////ALU_A_Sel//////////
`define ALU_A_Grt 3'b000
`define ALU_A_Grs 3'b001


///////////ALU_B_Sel//////////
`define ALU_B_imm32 3'b000
`define ALU_B_shamt 3'b001
`define ALU_B_Grs 3'b010
`define ALU_B_Grt 3'b011


///////////GRF_A3//////////
`define RegDst_rt 3'b000
`define RegDst_rd 3'b001
`define RegDst_31 3'b010

///////////BEOp///////////
`define BE_word 3'b000
`define BE_halfword 3'b001
`define BE_byte 3'b010

///////////DEOp///////////
`define DE_word 3'b000
`define DE_halfword 3'b001
`define DE_byte 3'b010
`define DE_unhalfword 3'b011
`define DE_unbyte 3'b100

/////////NPCOp/////////
`define NPC_branch 3'b000
`define NPC_j_jal 3'b001
`define NPC_jr_jalr 3'b010
`define NPC_else 3'b011

///////////CMPOp///////////
`define CMP_beq 3'b000
`define CMP_bne 3'b001
`define CMP_blez 3'b010

///////////MDOp///////////
`define MD_mult 4'b0000
`define MD_multu 4'b0001
`define MD_div 4'b0010
`define MD_divu 4'b0011
`define MD_mthi 4'b0100
`define MD_mtlo 4'b0101
`define MD_mfhi 4'b0110
`define MD_mflo 4'b0111
`define MD_else 4'b1000



