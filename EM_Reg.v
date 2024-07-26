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
    output reg [31:0] M_imm32,
	 
	 
	 input E_Exc_Ovload,
	 output reg M_Exc_Ovload,
	 input E_Exc_Ovstore,
	 output reg M_Exc_Ovstore,
	 
	 
	 input [4:0] E_ExcCode,
	 output reg [4:0] M_ExcCode,
	 input E_BD,
	 output reg M_BD,
	 input Req
	 
    );
	 
initial begin
		M_pc = 0;
		M_instr = 0;
		M_Grt = 0;
		M_ALU_result = 0;
		M_imm32 = 0;
		M_b_judge = 0;
		M_MD_out = 0;
		M_ExcCode = 0;
		M_BD = 0;
		M_Exc_Ovload = 0;
		M_Exc_Ovstore = 0;

end
always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1)|| (Req == 1'b1))begin
		M_pc <= Req? 32'h4180 :0;
		M_instr <= 0;
		M_Grt <= 0;
		M_ALU_result <= 0;
		M_imm32 <= 0;
		M_b_judge <= 0;
		M_MD_out <= 0;
		M_ExcCode <= 0;
		M_BD <= 0;
		M_Exc_Ovload <= 0;
		M_Exc_Ovstore<= 0;
	end
	else if(en == 1'b1)begin
		M_pc <= E_pc;
		M_instr <= E_instr;
		M_Grt <= E_Grt;
		M_ALU_result <= E_ALU_result;
		M_imm32 <= E_imm32;
		M_b_judge <= E_b_judge;
		M_MD_out <= E_MD_out;
		M_ExcCode <= E_ExcCode;
		M_BD <= E_BD;
		M_Exc_Ovload <= E_Exc_Ovload;
		M_Exc_Ovstore<= E_Exc_Ovstore;
	end
end

endmodule
