`timescale 1ns / 1ps
`include "define.v"
module CMP(
    input [31:0] A,
    input [31:0] B,
    input [2:0] CMPOp,
    output reg CMP_result
    );

always@(*)begin
	case(CMPOp)
		`CMP_beq:begin
			if(A == B)begin
				CMP_result = 1'b1;
			end
			else begin
				CMP_result = 1'b0;
			end
		end
		`CMP_bne:begin
			if(A != B)begin
				CMP_result = 1'b1;
			end
			else begin
				CMP_result = 1'b0;
			end
		end
		`CMP_blez:begin	//其他类比罢
			if(A[31]==1'b1 && ((|A)!=0))begin
				CMP_result = 1'b1;
			end
			else begin
				CMP_result = 1'b0;
			end
		end
		default:begin
			CMP_result = 1'b0;
		end
	
	endcase
end

endmodule
