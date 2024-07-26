`timescale 1ns / 1ps

module FD_Reg(
	input clk,
	input reset,
	input clear,
	input en,
	input Req,
	input F_b_judge,
	output reg D_b_judge,	
	input  [31:0] F_pc,
	input  [31:0] F_instr,
	output reg [31:0] D_pc,
	output reg [31:0] D_instr,
	
	
	input [4:0] F_ExcCode,
	output reg [4:0] D_ExcCode,
	input F_BD,
	output reg D_BD
	
    );
	 
initial begin
		D_pc = 0;
		D_instr = 0;
		D_b_judge = 0;
		D_ExcCode = 0;
		D_BD = 0;
end
always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1) || (Req == 1'b1))begin /////FD清空延时槽 非阻塞且满足清空条件&&(en != 1'b0)
		D_pc <= Req? 32'h4180 :0;
		D_instr <= 0;
		D_b_judge <= 0;
		D_ExcCode <= 0;
		D_BD <= 0;
	end
	else if(en == 1'b1)begin
		D_pc <= F_pc;
		D_instr <= F_instr;
		D_b_judge <= F_b_judge;
		D_ExcCode <= F_ExcCode;
		D_BD <= F_BD;
	end
end
endmodule
