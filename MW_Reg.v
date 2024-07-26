`timescale 1ns / 1ps

module MW_Reg(
    input clk,
    input reset,
    input clear,
    input en,
    input [31:0] M_pc,
    input [31:0] M_instr,
	 input [31:0] M_imm32,

    input [31:0] M_DM_RD,
    input [31:0] M_ALU_result,
	 input [31:0] M_MD_out,
	 
	 input M_b_judge,
	 output reg W_b_judge,
	 
    output reg [31:0] W_pc,
    output reg [31:0] W_instr,
    output reg [31:0] W_DM_RD,
    output reg [31:0] W_ALU_result,
    output reg [31:0] W_imm32,
	 output reg [31:0] W_MD_out,
	 
	 input Req,
	 input [31:0] M_CP0_out,
	 output reg [31:0] W_CP0_out
    );
initial begin
		W_pc = 0;
		W_instr = 0;
		W_DM_RD = 0;
		W_ALU_result = 0;
		W_imm32 = 0;
		W_b_judge = 0;
		W_MD_out = 0;
		W_CP0_out = 0;
end

always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1)|| (Req == 1'b1))begin
		W_pc <= Req? 32'h4180 :0;
		W_instr <= 0;
		W_DM_RD <= 0;
		W_ALU_result <= 0;
		W_imm32<= 0;
		W_b_judge<= 0;
		W_MD_out <= 0;
		W_CP0_out <= 0;
	end
	else if(en == 1'b1)begin
		W_pc <= M_pc;
		W_instr <= M_instr;
		W_DM_RD <= M_DM_RD;
		W_ALU_result <= M_ALU_result;
		W_imm32 <= M_imm32;
		W_b_judge <= M_b_judge;
		W_MD_out <= M_MD_out;
		W_CP0_out <= M_CP0_out;
	end
end

endmodule
