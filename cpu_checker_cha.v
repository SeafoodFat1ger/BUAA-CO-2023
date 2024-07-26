`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:06 08/29/2023 
// Design Name: 
// Module Name:    cpu_checker_cha 
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
`define S14 4'b1110

module cpu_checker(
	input clk,
	input reset,
	input [7:0] char,
	input [15:0] freq,
	output [1:0] format_type,
	output [3:0] error_code
    );
reg [3:0] status;
reg [2:0] cnt_time;
reg [3:0] cnt_pc;
reg [2:0] cnt_grf;
reg [3:0] cnt_addr;
reg [3:0] cnt_data;
reg [15:0] t;
reg [31:0] pc;
reg [6:0] grf;
reg [31:0] addr;
reg [3:0] error;
reg flag;

initial begin
status = `S0;
cnt_time = 0;
cnt_pc = 0;
cnt_grf = 0;
cnt_addr = 0;
cnt_data = 0;
flag = 0;
t = 0;
pc = 0;
grf = 0;
addr = 0;
error = 0;
end

always@(posedge clk) begin
	if(reset == 1) begin
		status <= `S0;
		cnt_time <= 0;
		cnt_pc <= 0;
		cnt_grf <= 0;
		cnt_addr <= 0;
		cnt_data <= 0;
		t <= 0;
		pc <= 0;
		grf <= 0;
		addr <= 0;
		error <= 0;
		flag <= 0;
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
					t <= (t<<3) + (t<<1) + char - "0";	//t=tx10+char-"0"
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
					status <= `S3;
					if((t & ((freq >> 1)-1)) != 0) begin	//检查t
						error <= error + 1;
					end
					t <= 0;
				end
				else if((char >= "0") && (char <= "9")) begin
					t <= (t<<3) + (t<<1) + char - "0";
					cnt_time <= cnt_time + 1;
					if (cnt_time <= 3) begin	//非阻塞
						status <= `S2;
					end
					else begin
						status <= `S0;
						t <= 0;
						error <= 0;
					end
				end 
				else if(char == "^") begin
					status <= `S1;
					t <= 0;
					error <= 0;
				end
				else begin
					status <= `S0;
					t <= 0;
					error <= 0;
				end
			end
			`S3 : begin
				if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					if((char >= "0") && (char <= "9")) begin
						pc <= (pc<<4) + char - "0";
					end
					else begin
						pc <= (pc<<4) + char - "a" + 10;
					end
					cnt_pc <= 1;
					status <= `S4;
				end
				else if(char == "^") begin
					status <= `S1;
					pc <= 0;
					error <= 0;
				end
				else begin
					status <= `S0;
					pc <= 0;
					error <= 0;
				end
			end
			`S4 : begin
				if(char == ":") begin
					if(cnt_pc == 8) begin
						status <= `S5;
						if(((pc & 3)!=0)||(pc < 32'h00003000)||(pc > 32'h00004fff)) begin	//检查pc
							error <= error + 2;
						end
					end
					else begin
						status <=`S0;
						error <= 0;
					end
					pc <= 0;		//pc置0
				end
				else if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					cnt_pc <= cnt_pc + 1;
					if((char >= "0") && (char <= "9")) begin
						pc <= (pc<<4) + char - "0";
					end
					else begin
						pc <= (pc<<4) + char - "a" + 10;
					end
					if(cnt_pc <= 7) begin
						status <= `S4;
					end
					else begin
						status <= `S0;
						pc <= 0;
						error <= 0;
					end
				end
				else if(char == "^") begin
					status <= `S1;
					pc <= 0;
					error <= 0;
				end
				else begin
					status <= `S0;
					pc <= 0;
					error <= 0;
				end
			end
			`S5 : begin
				if(char == " ") begin
					status <= `S5;
				end
				else if(char == "$") begin
					status <= `S6;
					flag <= 0;
				end
				else if(char == 8'd42) begin //用ASCII码8'd42来替代addr的前导字符
					status <= `S7;
					flag <= 1;
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S6 : begin
				if((char >= "0") && (char <= "9")) begin
					status <= `S8;
					cnt_grf <= 1;
					grf <= (grf<<3) + (grf<<1) + char - "0";
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S7 : begin
				if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					status <= `S9;
					cnt_addr <= 1;
					if((char >= "0") && (char <= "9")) begin
						addr <= (addr<<4) + char - "0";
					end
					else begin
						addr <= (addr<<4) + char - "a" + 10;
					end
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S8 : begin
				if(char == " ") begin
					status <= `S10;
					if((grf < 0) || (grf > 31)) begin	//检查grf
						error <= error + 8;
					end
					grf <= 0;
				end
				else if((char >= "0") && (char <= "9")) begin
					grf <= (grf<<3) + (grf<<1) + char - "0";
					cnt_grf <= cnt_grf + 1;
					if (cnt_grf <= 3) begin
						status <= `S8;
					end
					else begin
						status <= `S0;
						grf <= 0;
						error <= 0;
					end
				end 
				else if(char == "<") begin
					status <= `S11;
					if((grf < 0) || (grf > 31)) begin	//检查grf
						error <= error + 8;
					end
					grf <= 0;
				end
				else if(char == "^") begin
					status <= `S1;
					grf <= 0;
					error <= 0;
				end
				else begin
					status <= `S0;
					grf <= 0;
					error <= 0;
				end
			end
			`S9 : begin
				if(char == " ") begin
					if(cnt_addr == 8) begin
						status <= `S10;
						if(((addr & 3)!=0)||(addr < 0)||(addr > 32'h00002fff)) begin	//检查addr
							error <= error + 4;
						end
					end
					else begin
						status <= `S0;
						error <= 0;
					end
					addr <= 0;
				end
				else if(char == "<") begin
					if(cnt_addr == 8) begin
						status <= `S11;
						if(((addr & 3)!=0)||(addr < 0)||(addr > 32'h00002fff)) begin	//检查addr
							error <= error + 4;
						end
					end
					else begin
						status <= `S0;
						error <= 0;
					end
					addr <= 0;
				end
				else if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					cnt_addr <= cnt_addr + 1;
					if((char >= "0") && (char <= "9")) begin
						addr <= (addr<<4) + char - "0";
					end
					else begin
						addr <= (addr<<4) + char - "a" + 10;
					end
					if (cnt_addr <= 7) begin
						status <= `S9;
					end
					else begin
						status <= `S0;
						addr <= 0;
						error <= 0;
					end
				end 
				else if(char == "^") begin
					status <= `S1;
					addr <= 0;
					error <= 0;
				end
				else begin
					status <= `S0;
					addr <= 0;
					error <= 0;
				end
			end
			`S10 : begin
				if(char == " ") begin
					status <= `S10;
				end
				else if(char == "<") begin
					status <= `S11;
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S11 : begin
				if(char == "=") begin
					status <= `S12;
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S12 : begin
				if(char == " ") begin
					status <= `S12;
				end
				else if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					cnt_data <= 1;
					status <= `S13;
				end
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S13 : begin
				if(char == "#") begin
					if(cnt_data == 8) begin
						status <= `S14;
					end
					else begin
						status <= `S0;
						error <= 0;
					end
				end
				else if(((char >= "0") && (char <= "9"))||((char >= "a") && (char <= "f"))) begin
					cnt_data <= cnt_data + 1;
					if (cnt_data <= 7) begin
						status <= `S13;
					end
					else begin
						status <= `S0;
						error <= 0;
					end
				end 
				else if(char == "^") begin
					status <= `S1;
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
				end
			end
			`S14 : begin
				if(char == "^") begin
					status <= `S1;  
					error <= 0;
				end
				else begin
					status <= `S0;
					error <= 0;
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
				error <= 0;
			end
		endcase
	end
end
assign error_code = (status !=  `S14) ? 4'b0000 : error;
assign format_type = (status !=  `S14) ? 2'b00 :
							(flag == 0) ? 2'b01: 2'b10;
endmodule
