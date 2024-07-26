`timescale 1ns / 1ps


`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11
module expr(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );
reg [1:0] state=`S0;
reg [1:0] next_state;
wire [1:0] charType =((in >= "0")&&(in <= "9"))?2'b00:
							((in == "+")||(in == "*"))?2'b01:2'b10;
always@(posedge clk or posedge clr)begin
	if(clr)begin
		state <= `S0;
		out <= 0;
	end
	else begin
		state <= next_state;
	end
end

always@(state,in)begin
	case(state)
		`S0:begin
			next_state = (charType == 2'b00)?`S1:`S3;
		end
		`S1:begin
			next_state = (charType == 2'b01)?`S2:`S3;
		end
		`S2:begin
			next_state = (charType == 2'b00)?`S1:`S3;
		end
		`S3:begin
			next_state = `S3;
		end
		default:begin
          next_state = `S3;
      end
	endcase
end

always@(state)begin
	out = (state == `S1) ? 1 : 0;
end




endmodule
