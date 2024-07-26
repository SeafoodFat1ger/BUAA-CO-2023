`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:30 08/24/2023 
// Design Name: 
// Module Name:    cpu_checker 
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
`define S12 4'b1100
`define S13 4'b1101

module cpu_checker(
	input clk,
	input reset,
	input [7:0] char,
	output [1:0] format_type
    );
reg [3:0] status;
reg [2:0] cnt_time;
reg [3:0] cnt_pc;
reg [2:0] cnt_grf;
reg [3:0] cnt_addr;
reg [3:0] cnt_data;
reg flag;

initial begin
status = `S0;
cnt_time = 0;
cnt_pc = 0;
cnt_grf = 0;
cnt_data = 0;
flag = 0;
end

always@(posedge clk) begin
	if(reset == 1) begin
		status <= `S0;
		cnt_time = 0;
		cnt_pc = 0;
		cnt_grf = 0;
		cnt_addr = 0;
		cnt_data = 0;
		flag = 0;
	end
	else begin
		case(status)
			`S0 : begin
				if(char == "^") begin
					status <= `S1;
				end
				else begin
					status <= `S0;
				end
			end
			`S1 : begin
				if((char >= "0") && (char <= "9")) begin
					status <= `S2;
					cnt_time <= 1;
				end
				else if(char == "^") begin
					status <= `S1;
				end
				else begin
					status <= `S0;
				end
			end
			`S2 : begin
				if(char == "@") begin
					if(cnt_time <= 4) begin
							status <= `S3;
							cnt_time <=0;
						end
						else begin
							status <= `S0;
							cnt_time <= 0;
						end
				end
				else if((char >= "0") && (char <= "9")) begin
					cnt_time <= cnt_time + 1;
					if (cnt_time <= 4) begin
						status <= `S2;
					end
					else begin
						status <= `S0;
						cnt_time <= 0;
					end
				end 
				else if(char == "^") begin
					status <= `S1;
					cnt_time <= 0;
				end
				else begin
					status <= `S0;
					cnt_time <= 0;
				end
			end
			`S3 : begin
				if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					if(cnt_pc==7) begin
							status <= `S4;
							cnt_pc <= 0;
						end
						else if (cnt_pc <7) begin
							cnt_pc <= cnt_pc + 1;
							status <= `S3;
						end
						else begin
							status <= `S0;
							cnt_pc <= 0;
						end
				end
				else if(char == "^") begin
					status <= `S1;
					cnt_pc <= 0;
				end
				else begin
					status <= `S0;
					cnt_pc <= 0;
				end
			end
			`S4 : begin
				if(char == ":") begin
					status <= `S5;
				end
				else if(char == "^") begin
					status <= `S1;
				end
				else begin
					status <= `S0;
				end
			end
			`S5 : begin
				if(char == " ") begin
					status <= `S5;
				end
				else if(char == "$") begin
					status <= `S6;
				end
				else if(char == "*") begin
					status <= `S7;
				end
				else if(char == "^") begin
					status <= `S1;
				end
				else begin
					status <= `S0;
				end
			end
			`S6 : begin
				if((char >= "0") && (char <= "9")) begin
					if (cnt_grf == 3) begin
							status <= `S8;
							cnt_grf <= 0;
							flag <= 0;
						end
						else if(cnt_grf < 3)
							cnt_grf <= cnt_grf + 1;
						else begin
							status <= `S0;
							cnt_grf <= 0;
						end
				end
				else if (char == " ") begin
					if (cnt_grf != 0) begin
							status <= `S8;
							flag <= 0;
							cnt_grf <= 0;
					end
					else begin
							status <= `S0;
							flag <= 0;
							cnt_grf <= 0;
					end
				end
				else if(char == "<") begin
					if((cnt_grf <= 4) && (cnt_grf >= 1)) begin
							status <= `S9;
							flag <= 0;
							cnt_grf <=0;
					end
					else begin
							status <= `S0;
							flag <= 0;
							cnt_grf <= 0;
					end
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0;
					cnt_grf <= 0;
				end
				else begin
					status <= `S0;
					flag <= 0;
					cnt_grf <= 0;
				end
			end
			`S7 : begin
				if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					if(cnt_addr==7) begin
							status <= `S8;
							cnt_addr <= 0;
							flag <= 1;
						end
						else if (cnt_addr <7) begin
							cnt_addr <= cnt_addr + 1;
							status <= `S7;
						end
						else begin
							status <= `S0;
							cnt_addr <= 0;
							flag <= 0;
						end
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0;
					cnt_addr <= 0;
				end
				else begin
					status <= `S0;
					flag <= 0;
					cnt_addr <= 0;
				end
			end
			`S8 : begin
				if(char == " ") begin
					status <= `S8;
				end
				else if(char == "<") begin
					status <= `S9;
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0;    
				end
				else begin
					status <= `S0;
					flag <= 0;
				end
			end
			`S9 : begin
				if(char == "=") begin
					status <= `S10;
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0;    
				end
				else begin
					status <= `S0;
					flag <= 0;
				end
			end
			`S10 : begin
				if(char == " ") begin
					status <= `S10;
				end
				else if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					status <= `S11;
					cnt_data <= 1;
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0;    
				end
				else begin
					status <= `S0;
					flag <= 0;
				end
			end
			`S11 : begin
				if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					if(cnt_data==7) begin
							status <= `S12;
							cnt_data <= 0;
						end
						else if (cnt_data <7) begin
							cnt_data <= cnt_data + 1;
							status <= `S7;
						end
						else begin
							status <= `S0;
							cnt_data <= 0;
							flag <= 0;
						end
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0; 
					cnt_data <= 0;
				end
				else begin
					status <= `S0;
					flag <= 0;
					cnt_data <= 0;
				end
			end
			`S12 : begin
				if(char == "#") begin
					status <= `S13;
				end
				else if(char == "^") begin
					status <= `S1;
					flag <= 0; 
				end
				else begin
					status <= `S0;
					flag <= 0;
				end
			end
			`S13 : begin
				if(char == "^") begin
					status <= `S1;
					flag <= 0; 
				end
				else begin
					status <= `S0;
					flag <= 0;
				end
			end
			default : begin
				status = `S0;
				cnt_time = 0;
				cnt_pc = 0;
				cnt_grf = 0;
				cnt_addr = 0;
				cnt_data = 0;
				flag <= 0;
			end
		endcase
	end
end
assign format_type = (status != `S13) ? 2'b00 :
							(flag == 0) ? 2'b01: 2'b10;
endmodule
