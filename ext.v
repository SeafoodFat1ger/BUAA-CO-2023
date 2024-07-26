`timescale 1ns / 1ps

module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
    );
	assign ext = 	(EOp == 2'b00 && imm[15]==1)?{16'b1111_1111_1111_1111,imm}:
						(EOp == 2'b00 && imm[15]==0)?{16'b0000_0000_0000_0000,imm}:
						(EOp == 2'b01)?{16'b0000_0000_0000_0000,imm}:
						(EOp == 2'b10)?{imm,16'b0000_0000_0000_0000}:
						(EOp == 2'b11 && imm[15]==1)?({16'b1111_1111_1111_1111,imm})<<2:
						(EOp == 2'b11 && imm[15]==0)?({16'b0000_0000_0000_0000,imm})<<2:
						0;
endmodule
