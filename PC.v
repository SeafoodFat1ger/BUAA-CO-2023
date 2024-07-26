`timescale 1ns / 1ps

module PC(
	input clk,
	input reset,
	input en,
	input Req,
	input [31:0] npc,
	output reg [31:0] pc
    );
initial begin
	pc = 32'h3000;
end
always @(posedge clk)begin
	if(reset)begin
		pc <= 32'h3000;
	end
   else if(en == 1'b1 || Req == 1'b1)begin
		pc <= npc;
	end
end
endmodule
