`timescale 1ns / 1ps

module FD_Reg(
	input clk,
	input reset,
	input clear,
	input en,
	input F_b_judge,
	output reg D_b_judge,	
	input  [31:0] F_pc,
	input  [31:0] F_instr,
	output reg [31:0] D_pc,
	output reg [31:0] D_instr
    );
always@(posedge clk)begin
	if((reset == 1'b1)||(clear == 1'b1 &&(en != 1'b0)))begin /////FD清空延时槽 非阻塞且满足清空条件
		D_pc <= 0;
		D_instr <= 0;
		D_b_judge <= 0;
	end
	else if(en == 1'b1)begin
		D_pc <= F_pc;
		D_instr <= F_instr;
		D_b_judge <= F_b_judge;
	end
end
endmodule
