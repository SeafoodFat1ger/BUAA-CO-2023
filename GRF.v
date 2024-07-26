`timescale 1ns / 1ps

module GRF(
	input [31:0] pc, 
	input clk,
	input reset,
	input RegWrite,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD,
	output [31:0] RD1,
	output [31:0] RD2
    );
reg [31:0] grf [0:31];
integer i = 0;

initial begin
	for(i = 0;i < 32;i = i+1)begin 
		grf[i] = 0;
	end
end
always @(posedge clk)begin
	if(reset)begin
		for(i = 0;i < 5'd31;i = i+1)begin
			grf[i] <= 0;
		end
	end
   else begin
        if (RegWrite == 1)begin
			  if(A3 == 5'b00000)begin
					grf[A3] <= 0;
			  end
			  else begin
					grf[A3] <= WD;
			  end
        end
    end
end
assign RD1 = (RegWrite && A1!=0 && A1 == A3)?WD:grf[A1];
assign RD2 = (RegWrite && A2!=0 && A2 == A3)?WD:grf[A2];
endmodule
