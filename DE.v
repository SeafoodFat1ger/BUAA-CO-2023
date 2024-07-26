`timescale 1ns / 1ps
`include <define.v>

`define dm_start 32'h0000
`define dm_end 32'h2fff
`define t0_start 32'h7f00
`define t0_end 32'h7f0b
`define t1_start 32'h7f10
`define t1_end 32'h7f1b
`define zd_start 32'h7f20
`define zd_end 32'h7f23


module DE(
	input [31:0] MemAddr,
	input M_Exc_Ovload,
	input [31:0] din,
	input [2:0] DEOp,
	output reg [31:0] dout,
	output M_Exc_AdEL
    );

wire is_load = (DEOp == `DE_word)||(DEOp == `DE_halfword)||(DEOp == `DE_byte);

wire byte_Err = (DEOp == `DE_word)?(MemAddr[1:0]!= 2'b00):
					(DEOp == `DE_halfword)?(MemAddr[0]!= 1'b0):1'b0;
					
wire range_Err = (MemAddr >= `dm_start && MemAddr <= `dm_end)||
					(MemAddr >= `t0_start && MemAddr <= `t0_end)||
					(MemAddr >= `t1_start && MemAddr <= `t1_end)||
					(MemAddr >= `zd_start && MemAddr <= `zd_end)? 1'b0:1'b1;


wire timer_Err = ((DEOp == `DE_byte)||(DEOp == `DE_halfword))&&
					((MemAddr >= `t0_start && MemAddr <= `t0_end)||(MemAddr >= `t1_start && MemAddr <= `t1_end))? 1'b1 : 1'b0;


assign M_Exc_AdEL = (is_load)&&( M_Exc_Ovload || byte_Err || range_Err || timer_Err );


//////////////////////////////////////////////////////////////////////////////

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
