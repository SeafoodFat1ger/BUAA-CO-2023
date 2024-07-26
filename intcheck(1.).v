`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:09:45 10/01/2023 
// Design Name: 
// Module Name:    intcheck 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1011
module intcheck(
    input clk,
    input reset,
    input [7:0] in,
    output out
    );
reg [3:0] status;
reg err;
reg flag;

initial begin
	status = 0;
	err = 0;
	flag = 0;
end
always @(posedge clk)begin
	if (reset == 1) begin
		status<= 0;
		err <= 0;
		flag <= 0;
	end
	else begin
		case(status)
			`S0:begin ///初始化
				err <= 0;
				flag <= 0;
				if(in == "i")begin
					status <= `S1;
				end
				else if(in == " "||in == "\t")begin
					status <= `S0;
				end
				else if(in == ";")begin
					status <= `S0;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S1:begin//输入i后
				if(in == "n")begin
					status <= `S2;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S2:begin//输入n后
				if(in == "t")begin
					status <= `S3;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S3:begin//输入t后
				if(in == " "||in == "\t")begin
					status <= `S4;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S4:begin//输入space后（必须一个以上空格
				if(in == " "||in == "\t")begin
					status <= `S4;
				end
				else if(in == "i") begin
					status <= `S7;///////////!
				end
				else if((in >= "A" && in<="Z")||(in >= "a" && in<="z")|||(in >= "_" ))begin
					status <= `S5;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S5:begin
				if((in >= "A" && in<="Z")||(in >= "a" && in<="z")||(in >= "0" && in<="9")||(in >= "_"))begin
					status <= `S5;
				end
				else if(in == " "||in == "\t") begin
					status <= `S6;
				end
				else if(in == ",") begin
					status <= `S10;
				end
				else if(in == ";") begin
					status <= `S0;///////
					flag <= 1;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S10:begin
				if(in == " "||in == "\t") begin
					status <= `S10;
				end
				else if(in == "i") begin
					status <= `S7;///////////!
				end
				else if((in >= "A" && in<="Z")||(in >= "a" && in<="z")||(in >= "_" ))begin
					status <= `S5;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S6:begin
				if(in == " "||in == "\t") begin
					status <= `S6;
				end
				else if(in == ",")begin
					status <= `S10;
				end
				else if(in == ";") begin
					status <= `S0;///////
					flag <= 1;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S7: begin
				if(in == "n")begin
					status <= `S8;
				end
				else if((in >= "A" && in<="Z")||(in >= "a" && in<="z")||(in >= "0" && in<="9")||(in >= "_" ))begin
					status <= `S5;
				end
				else if(in == " "||in == "\t") begin
					status <= `S6;
				end
				else if(in == ",") begin
					status <= `S10;
				end
				else if(in == ";") begin
					status <= `S0;///////
					flag <= 1;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S8: begin
				if(in == "t")begin
					status <= `S9;
				end
				else if((in >= "A" && in<="Z")||(in >= "a" && in<="z")||(in >= "0" && in<="9")||(in >= "_" ))begin
					status <= `S5;
				end
				else if(in == " "||in == "\t") begin
					status <= `S6;
				end
				else if(in == ",") begin
					status <= `S10;
				end
				else if(in == ";") begin
					status <= `S0;///////
					flag <= 1;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S9: begin
				if(in == " "||in == "\t")begin
					status <= `S6;
					err <= 1;
				end
				else if(in == ",") begin
					status <= `S10;
					err <= 1;
				end
				else if(in == ";") begin
					status <= `S0;
					flag <= 1;
					err <= 1;
				end
				else if((in >= "A" && in<="Z")||(in >= "a" && in<="z")||(in >= "0" && in<="9")||(in >= "_" ))begin
					status <= `S5;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
			`S11:begin
				if(in == ";")begin
					status <= `S0;
					err <= 1;
				end
				else begin
					status <= `S11;
					err <= 1;
				end
			end
		endcase
	end
end
assign out = (err == 0 && flag == 1)? 1:0;
endmodule
