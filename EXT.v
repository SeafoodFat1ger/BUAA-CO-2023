`timescale 1ns / 1ps

module EXT(
    input [15:0] imm16,
    input [2:0] EXTsign,
    output [31:0] imm32
    );

assign imm32  = 	(EXTsign == 3'b10 && imm16[15]==1)?{16'b1111_1111_1111_1111,imm16}:
						(EXTsign == 3'b10 && imm16[15]==0)?{16'b0000_0000_0000_0000,imm16}:
						(EXTsign == 3'b1 )?{imm16,{16{1'b0}}}:
						(EXTsign == 0)?{16'b0000_0000_0000_0000,imm16}:
						0;
endmodule
