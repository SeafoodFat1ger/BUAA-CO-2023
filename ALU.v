`timescale 1ns / 1ps
`include "define.v"
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] ALUresult,
    output equal
    );
always@(*)begin
	case(ALUOp)
		`ALU_add:begin
			ALUresult = A + B;
		end
		`ALU_sub:begin
			ALUresult = A - B;
		end
		`ALU_ori:begin
			ALUresult = A | B;
		end
		`ALU_lui:begin
			ALUresult = B << 16;
		end
	endcase
end
assign equal = (A == B)? 1:0;
endmodule
