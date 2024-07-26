`timescale 1ns / 1ps

module MUX_8_5(
    input [2:0] Op,
    input [4:0] data1,
    input [4:0] data2,
    input [4:0] data3,
    input [4:0] data4,
    output [4:0] out
    );
assign out = (Op == 3'b000)?data1:
					(Op == 3'b001)?data2:
					(Op == 3'b010)?data3:
					data4;

endmodule
