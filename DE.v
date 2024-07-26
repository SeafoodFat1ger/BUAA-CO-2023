`timescale 1ns / 1ps
`include <define.v>

module DE(
	input [31:0] MemAddr,
	input [31:0] din,
	input [2:0] DEOp,
	output reg [31:0] dout
    );
always @(*)begin
	case(DEOp)
		`DE_word: begin
			dout = din;
		end
		`DE_halfword:begin
			if(MemAddr[1] == 0)begin
				dout = {{16{din[15]}},din[15:0]};
			end
			else begin
				dout = {{16{din[31]}},din[31:16]};
			end
		end
		`DE_unhalfword:begin
			if(MemAddr[1] == 0)begin
				dout = {{16{1'b0}},din[15:0]};
			end
			else begin
				dout = {{16{1'b0}},din[31:16]};
			end
		end
		`DE_byte:begin
			if(MemAddr[1:0] == 2'b00)begin
				dout = {{24{din[7]}},din[7:0]};
			end
			else if(MemAddr[1:0] == 2'b01)begin
				dout = {{24{din[15]}},din[15:8]};
			end
			else if(MemAddr[1:0] == 2'b10)begin
				dout = {{24{din[23]}},din[23:16]};
			end
			else begin
				dout = {{24{din[31]}},din[31:24]};
			end
		end
		`DE_unbyte:begin
			if(MemAddr[1:0] == 2'b00)begin
				dout = {{24{1'b0}},din[7:0]};
			end
			else if(MemAddr[1:0] == 2'b01)begin
				dout = {{24{1'b0}},din[15:8]};
			end
			else if(MemAddr[1:0] == 2'b10)begin
				dout = {{24{1'b0}},din[23:16]};
			end
			else begin
				dout = {{24{1'b0}},din[31:24]};
			end
		end
	endcase
end
endmodule
