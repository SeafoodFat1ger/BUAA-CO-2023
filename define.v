///////////opcode////////////
//////ºÏ≤È”–Œﬁ≥ÂÕª/////
`define opcode_add 6'b000000
`define opcode_sub 6'b000000
`define opcode_ori 6'b001101
`define opcode_lw 6'b100011
`define opcode_sw 6'b101011
`define opcode_beq 6'b000100
`define opcode_lui 6'b001111
`define opcode_jal 6'b000011
`define opcode_jr 6'b000000
`define opcode_jalr 6'b000000
`define opcode_j 6'b000010
`define opcode_lb 6'b100000
`define opcode_lh 6'b100001
`define opcode_sb 6'b101000
`define opcode_sh 6'b101001

///////////funcode//////////////
`define funcode_add 6'b100000
`define funcode_sub 6'b100010
`define funcode_jr 6'b001000
`define funcode_jalr 6'b001001
////////////GRF_WD_Sel///////////
`define Reg_pcplus8 3'b000
`define Reg_dmrd 3'b001
`define Reg_ALUresult 3'b010
`define Reg_lui 3'b011
///////////ALUOp//////////////
`define ALU_add 3'b000
`define ALU_sub 3'b001
`define ALU_ori 3'b010
`define ALU_lui 3'b011

///////////ALU_B_Sel//////////
`define ALUSrc_Grt 3'b000
`define ALUSrc_imm32 3'b001

///////////GRF_A3//////////
`define RegDst_rt 3'b000
`define RegDst_rd 3'b001
`define RegDst_31 3'b010

///////////DMOp///////////
`define DM_word 3'b000
`define DM_halfword 3'b001
`define DM_byte 3'b010


/////////NPCOp/////////
`define NPC_branch 3'b000
`define NPC_j_jal 3'b001
`define NPC_jr_jalr 3'b010
`define NPC_else 3'b011

///////////CMPOp///////////
`define CMP_beq 3'b000
`define CMP_bne 3'b001
`define CMP_blez 3'b010







