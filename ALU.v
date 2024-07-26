`timescale 1ns / 1ps
`include "define.v"
module ALU(
	 input E_is_Ov,
	 input E_is_load,
	 input E_is_store,
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    output reg [31:0] ALUresult,
	 output E_Exc_Ov,
	 output E_Exc_Ovload,
	 output E_Exc_Ovstore
    );
wire [32:0] AaddB = {A[31],A} + {B[31],B};
wire [32:0] AsubB = {A[31],A} - {B[31],B};

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

wire E_overflow = (ALUOp == `ALU_add)?(AaddB[31] != AaddB[32]):
							(ALUOp == `ALU_sub)?(AsubB[31] != AsubB[32]):
							1'b0;
assign E_Exc_Ov = (E_overflow && E_is_Ov);
assign E_Exc_Ovload = (E_overflow && E_is_load);
assign E_Exc_Ovstore = (E_overflow && E_is_store);
endmodule
