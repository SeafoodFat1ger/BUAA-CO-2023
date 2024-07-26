`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:19 08/23/2023 
// Design Name: 
// Module Name:    id_fsm 
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
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
module id_fsm(
	input [7:0] char,
	input clk,
	output out
    );
reg [1:0] status;

initial
begin
	status <= `S0;
end

always@(posedge clk)
begin
	case(status)
	`S0 : begin
				if ((char >="A")&&(char <="Z")||(char >= "a")&&(char <="z"))
				begin
					status <= `S1;
				end
				else if ((char >= "0") && (char <= "9"))
				begin
					status <= `S0;
				end
				else 
				begin
					status <= `S0; //对于一切非正常输出，回到状态0
				end
			end
	
	`S1 : begin
				if ((char >="A")&&(char <="Z")||(char >= "a")&&(char <="z"))
				begin
					status <= `S1;
				end
				else if ((char >= "0") && (char <= "9"))
				begin
					status <= `S2;
				end
				else 
				begin
					status <= `S0; //对于一切非正常输出，回到状态0
				end
			end
			
	`S2 : begin
				if ((char >="A")&&(char <="Z")||(char >= "a")&&(char <="z"))
				begin
					status <= `S1;
				end
				else if ((char >= "0") && (char <= "9"))
				begin
					status <= `S2;
				end
				else 
				begin
					status <= `S0; //对于一切非正常输出，回到状态0
				end
			end
	default:begin
		status <= `S0;
	end
		
	endcase
end

assign out = (status == `S2) ? 1'b1 : 1'b0;
endmodule
