`timescale 1ns / 1ps


`define S0 3'b000
`define S1 3'b001
`define S2 3'b010
`define S3 3'b011
`define S4 3'b100
module string2(
    input clk,
    input clr,
    input [7:0] in,
    output  out
    );
reg [2:0] state=`S0;
reg [1:0] next_state;
wire [2:0] charType =((in >= "0")&&(in <= "9"))?3'b000:
							((in == "+")||(in == "*"))?3'b001:
							(in == "(")?3'b010:
							(in == ")")?3'b011:
							3'b100;
always@(posedge clk or posedge clr)begin
	if(clr)begin
		state <= `S0;
	end
	else begin
		case(state)
		`S0:begin
			if(charType == 3'b000)begin
				state <= `S1;
			end
			else if(charType == 3'b010)begin
				state <= `S2;
			end
			else begin
				state <= `S4;
			end
		end
		`S1:begin
			state <= (charType == 3'b001)?`S0:`S4;
		end
		`S2:begin
			state <= (charType == 3'b000)?`S3:`S4;
		end
		`S3:begin
			if(charType == 3'b001)begin
				state <= `S2;
			end
			else if(charType == 3'b011)begin
				state <= `S1;
			end
			else begin
				state <= `S4;
			end
		end
		`S4:begin
			state <= `S4;
		end
		default:begin
          state <= `S4;
      end
	endcase
	end
end



	assign out = (state == `S1) ? 1 : 0;





endmodule
