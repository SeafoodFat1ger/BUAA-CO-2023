`timescale 1ns / 1ps

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
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
reg [3:0] state;
integer right=0;
integer left=0;
initial begin
	state <= `S0;
end
always @(posedge clk or posedge reset)begin
	if (reset == 1)begin
		state <= `S0;
		right <= 0;
		left <= 0;
	end 
	else begin
		case(state)
			`S0: begin//开始新单词
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "B"||in == "b")begin
					state <= `S2;
				end
				else if(in == "E"||in == "e")begin
					state <= `S7;
				end
				else begin
					state <= `S1;
				end
			end
			`S1:begin//其他的单词
				if(in == " ")begin
					state <= `S0;
				end
				else begin
					state <= `S1;
				end
			end
			`S2:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "E"||in == "e")begin
					state <= `S3;
				end
				else begin
					state <= `S1;
				end
			end
			`S3:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "G"||in == "g")begin
					state <= `S4;
				end
				else begin
					state <= `S1;
				end
			end
			`S4:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "I"||in == "i")begin
					state <= `S5;
				end
				else begin
					state <= `S1;
				end
			end
			`S5:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "N"||in == "n")begin
					state <= `S6;
					left <= left + 1;
				end
				else begin
					state <= `S1;
				end
			end
			`S6:begin
				if(in == " ")begin
					state <= `S0;
				end
				else begin
					state <= `S1;
					left <= left -1;
				end
			end
			`S7:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "N"||in == "n")begin
					state <= `S8;
				end
				else begin
					state <= `S1;
				end
			end
			`S8:begin
				if(in == " ")begin
					state <= `S0;
				end
				else if(in == "D"||in == "d")begin
					state <= `S9;
					right <= right + 1;
				end
				else begin
					state <= `S1;
				end
			end
			`S9:begin
				if(in == " ")begin
					state <= `S0;
				end
				else begin
					state <= `S1;
					right <= right - 1;
				end
			end
		endcase
	end
end

assign result = (right == left)?1:0;
endmodule
