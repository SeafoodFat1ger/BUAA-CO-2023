`timescale 1ns / 1ps

module IM(
	input [31:0] pc, 
	output [31:0] instr
    );
reg [31:0] ROM [0:4095];
integer i = 0;
initial begin
	for(i = 0;i < 4096;i = i+1)begin 
		ROM[i] = 0;
	end
    $readmemh("code.txt", ROM , 0);
end
wire [31:0] i_32 = pc - 32'h3000;
wire [11:0] i_12 = i_32 [13:2];
assign instr = ROM[i_12];
endmodule
