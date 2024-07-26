`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:25 10/01/2023 
// Design Name: 
// Module Name:    FloatType 
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
module FloatType(
    input [31:0] num,
    output [4:0] float_type
    );
wire a = (num[30:23]==8'b0000_0000)?1:0;
wire b = (num[30:23]==8'b1111_1111)?1:0;
wire c = (num[22:0]==0)?1:0;
assign float_type = (a == 1 && c == 1)? 5'b00001:
							(a == 0 && b == 0)? 5'b00010:
							(a == 1 && c == 0)? 5'b00100:
							(b == 1 && c == 1)? 5'b01000:
							(b == 1 && c == 0)? 5'b10000:0;
endmodule
