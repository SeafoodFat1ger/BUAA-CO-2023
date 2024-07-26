`timescale 1ns / 1ps

module gray(
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
    );
initial begin
	Output = 0;
	Overflow = 0;
end
always@(posedge Clk) begin
	if(Reset == 1) begin
		Output <= 0;
		Overflow <= 0;
	end
	else begin
		if(En == 1)begin
			case(Output)
				3'b000 : begin
					Output <= 3'b001;
				end
				3'b001 : begin
					Output <= 3'b011;
				end
				3'b010 : begin
					Output <= 3'b110;
				end
				3'b011 : begin
					Output <= 3'b010;
				end
				3'b100 : begin
					Output <= 3'b000;
					Overflow <= 1;
				end
				3'b101 : begin
					Output <= 3'b100;
				end
				3'b110 : begin
					Output <= 3'b111;
				end
				3'b111 : begin
					Output <= 3'b101;
				end
			endcase	
		end
	end
end

endmodule
