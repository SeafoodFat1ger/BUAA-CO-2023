`timescale 1ns / 1ps
`include "define.v"
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    output reg [31:0] ALUresult
    );
always@(*)begin
	case(ALUOp)
		`ALU_add:begin
			ALUresult = A + B;
		end
		`ALU_sub:begin
			ALUresult = A - B;
		end
		`ALU_or:begin
			ALUresult = A | B;
		end
		`ALU_lui:begin
			ALUresult = B;
		end
		`ALU_and:begin
			ALUresult = A & B;
		end
		`ALU_slt:begin
			ALUresult = $signed(A) < $signed(B);
		end
		`ALU_sltu:begin
			ALUresult = A < B;
		end
		`ALU_left:begin
			ALUresult = A << B;		//$signed($signed(A) >>> $signed(B)) À„ ˝”““∆
		end		
		
	endcase
end
endmodule
