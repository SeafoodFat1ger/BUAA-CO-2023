`timescale 1ns / 1ps
`include<define.v>

module MD(
	 input Req, 
    input clk,
    input reset,
    input start,
    input [3:0] MDOp,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] HI,
    output reg [31:0] LO,
    output [31:0] out,
    output reg busy
    );

reg [4:0] cnt;
reg [31:0] HI_temp;
reg [31:0] LO_temp;

initial begin
		cnt <= 0;
		busy <= 0;
		HI <= 0;
		LO <= 0;
		HI_temp <= 0;
		LO_temp <= 0;

end

always@(posedge clk)begin
	if(reset)begin
		cnt <= 0;
		busy <= 0;
		HI <= 0;
		LO <= 0;
		HI_temp <= 0;
		LO_temp <= 0;
	end
	else if(Req == 1'b0)begin
		if(cnt == 0)begin
			if(start)begin
				busy <= 1;
				case(MDOp)
					`MD_mult:begin
						cnt <= 5;
						{HI_temp,LO_temp} <= $signed(A)*$signed(B);
					end
					`MD_multu:begin
						cnt <= 5;
						{HI_temp,LO_temp} <= A*B;
					end
					`MD_div:begin
						cnt <= 10;
						LO_temp = $signed(A)/$signed(B);
						HI_temp = $signed(A)%$signed(B);
					end
					`MD_divu:begin
						cnt <= 10;
						LO_temp = A/B;
						HI_temp = A%B;
					end
				endcase	
			end
			else if(MDOp == `MD_mthi) begin
				cnt <= 0;
				HI <= A;
			end
			else if(MDOp == `MD_mtlo) begin
				cnt <= 0;
				LO <= A; 
			end
			else begin
				cnt <= 0;
			end
		end
		else if(cnt == 1)begin
			cnt <= 0;
			busy <= 0;
			{HI,LO} <= {HI_temp,LO_temp};
		end
		else begin
			cnt <= cnt -1;
		end
	end
end

/*
always@(posedge clk) begin
	if(MDOp == `MD_mthi) begin
		HI <= A;
	end
	else if(MDOp == `MD_mtlo) begin
		LO <= A; 
	end
end
*/

assign out = (MDOp == `MD_mfhi)?HI:
					(MDOp == `MD_mflo)?LO:
					0;

endmodule
