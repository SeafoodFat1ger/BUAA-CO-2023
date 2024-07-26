`timescale 1ns / 1ps

module EM_Reg(
    input clk,
    input reset,
    input clear,
    input en,
    input [31:0] E_pc,
    input [31:0] E_instr,
    input [31:0] E_Grt,
    input [31:0] E_ALU_result,
	 input [31:0] E_imm32,
	 input [31:0] E_MD_out,
	 
	 input E_b_judge,
	 output reg M_b_judge,
	 
	 output reg [31:0] M_MD_out,
    output reg [31:0] M_pc,
    output reg [31:0] M_instr,
    output reg [31:0] M_Grt,
    output reg [31:0] M_ALU_result,
    output reg [31:0] M_imm32
    );
always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1))begin
		M_pc <= 0;
		M_instr <= 0;
		M_Grt <= 0;
		M_ALU_result <= 0;
		M_imm32 <= 0;
		M_b_judge <= 0;
		M_MD_out <= 0;
	end
	else if(en == 1'b1)begin
		M_pc <= E_pc;
		M_instr <= E_instr;
		M_Grt <= E_Grt;
		M_ALU_result <= E_ALU_result;
		M_imm32 <= E_imm32;
		M_b_judge <= E_b_judge;
		M_MD_out <= E_MD_out;
	end
end

endmodule
