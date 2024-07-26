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
`define S10 4'b1010
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
reg [3:0] state=`S0;
reg [3:0] next_state;
integer right=0;
integer left=0;
reg flag = 0;
always @(posedge clk or posedge reset)begin
	if(reset)begin
		state <= `S0;
		right <= 0;
		left <= 0;
		flag <=0;
	end
	else begin
		state<=next_state;
	end
end


assign result=(left==right&&flag==0)?1:0;


always@(posedge clk or posedge reset)begin
	if(reset)begin
		state <= `S0;
		right <= 0;
		left <= 0;
		flag <=0;
	end
	else begin
		case(state)
			`S5:begin
				if((in == "n")||(in =="N"))begin
					left<=left+1;
				end
				else begin
					left<=left;
				end
			end
			`S6:begin
				if(in == " ")begin
					left<=left;
				end
				else begin
					left<=left-1;
				end
			end
			`S8:begin
				if((in == "d")||(in =="D"))begin
					right<=right+1;
				end
				else begin
					right<=right;
				end
			end
			`S9:begin
				if(in == " ")begin
					if(left<right)begin
						flag<=1;
					end
					right <= right;
				end
				else begin
					right=right-1;
				end
			end
		endcase
	end
end
always@(state,in)begin
	case(state)
		`S0:begin
			if((in == "b")||(in =="B"))begin
				next_state = `S2;
			end
			else if((in == "e")||(in =="E"))begin
				next_state = `S7;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S1:begin
			if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S2:begin
			if((in == "e")||(in =="E"))begin
				next_state = `S3;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S3:begin
			if((in == "g")||(in =="G"))begin
				next_state = `S4;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S4:begin
			if((in == "i")||(in =="I"))begin
				next_state = `S5;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S5:begin
			if((in == "n")||(in =="N"))begin
				next_state = `S6;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end			
		end
		`S6:begin
			if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S7:begin
			if((in == "n")||(in =="N"))begin
				next_state = `S8;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S8:begin
			if((in == "d")||(in =="D"))begin
				next_state = `S9;
			end
			else if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		`S9:begin
			if(in == " ")begin
				next_state = `S0;
			end
			else begin
				next_state = `S1;
			end
		end
		default:begin
			next_state = `S10;
		end
	endcase
end
endmodule
