`timescale 1ns / 1ps

`define IM SR[15:10]
`define EXL SR[1]
`define IE SR[0]
`define BD Cause[31]
`define IP Cause[15:10]
`define ExcCode Cause[6:2]

module CP0(
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
	 input BD,
    input [31:0] Din,
    input [31:0] PC,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input WE,
    input EXLClr,
    output Req,
    output [31:0] EPCOut,
    output [31:0] Dout
    );

reg [31:0] SR;
reg [31:0] Cause;
reg [31:0] EPC;

wire Int_Req = (|(HWInt & `IM)) && `IE && !`EXL;
wire Exc_Req = (| ExcCodeIn) && !`EXL;
assign Req = Int_Req | Exc_Req;

wire [31:0] EPC_tmp = (Req)?(BD ? (PC - 4):PC):EPC;
assign EPCOut = EPC_tmp;
assign Dout = (A1 == 12)? SR:
					(A1 == 13)? Cause:
					(A1 == 14)? EPCOut:0;

always @(posedge clk or posedge reset) begin
	if(reset)begin
		SR <= 0;
		Cause <= 0;
		EPC <= 0;
		
	end
	else if(Req)begin
		`EXL <= 1'b1;
		`BD <= BD;
		 EPC <= EPC_tmp;
		`ExcCode <= Int_Req ? 5'd0 : ExcCodeIn;
	end
	else if(EXLClr) begin
		`EXL <= 1'b0;
	end
	else if(WE)begin
		if(A2 == 5'd12)begin
			SR <= Din;
		end
		else if(A2 == 5'd14)begin
			EPC <= Din;
		end
	end
	
	if(!reset)begin
		`IP <= HWInt;
	end
end


endmodule
