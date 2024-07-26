`timescale 1ns / 1ps

module DE_Reg(
    input clk,
    input reset,
    input clear,
    input en,
    input [31:0] D_pc,
    input [31:0] D_instr,
    input [31:0] D_Grs,
    input [31:0] D_Grt,
	 input [31:0] D_imm32,
	 
	 input D_b_judge,
	 output reg E_b_judge,
	 
    output reg [31:0] E_pc,
    output reg [31:0] E_instr,
    output reg [31:0] E_Grs,
    output reg [31:0] E_Grt,
	 output reg [31:0] E_imm32
    );
always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1))begin
		E_pc <= 0;
		E_instr <= 0;
		E_Grs <= 0;
		E_Grt <= 0;
		E_imm32 <= 0;
		E_b_judge <= 0;
	end
	else if(en == 1'b1)begin
		E_pc <= D_pc;
		E_instr <= D_instr;
		E_Grs <= D_Grs;
		E_Grt <= D_Grt;
		E_imm32 <= D_imm32;
		E_b_judge <= D_b_judge;
	end
end

endmodule
