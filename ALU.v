`timescale 1ns / 1ps

module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output [31:0] C
    );
	wire[31:0] D = $signed(A)>>>B;
	assign C = 	(ALUOp == 0)?A+B:
					(ALUOp == 1)?A-B:
					(ALUOp == 2)?A&B:
					(ALUOp == 3)?A|B:
					(ALUOp == 4)?A>>B:
					(ALUOp == 5)?D:
					0;

endmodule
