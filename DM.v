`timescale 1ns / 1ps
`include "define.v"
module DM(
	input [31:0] pc,
	input clk,
	input reset,
	input MemWrite,
	input [31:0] MemAddr,
	input [2:0] DMOp,
	input [31:0] din,
	output reg [31:0] dout
    );
reg [31:0] RAM [0:3071];
integer i = 0;
///这玩意根本不能综合啊？？？？？？
initial begin
	for(i = 0;i < 3072;i = i+1)begin
		RAM[i] = 0;
	end
end

always @(*)begin
	case(DMOp)
		`DM_word: begin
			dout = RAM[MemAddr[13:2]];
		end
		`DM_halfword:begin
			if(MemAddr[1] == 0)begin
				dout = {{16{RAM[MemAddr[13:2]][15]}},RAM[MemAddr[13:2]][15:0]};
			end
			else begin
				dout = {{16{RAM[MemAddr[13:2]][31]}},RAM[MemAddr[13:2]][31:16]};
			end
		end
		`DM_byte:begin
			if(MemAddr[1:0] == 2'b00)begin
				dout = {{24{RAM[MemAddr[13:2]][7]}},RAM[MemAddr[13:2]][7:0]};
			end
			else if(MemAddr[1:0] == 2'b01)begin
				dout = {{24{RAM[MemAddr[13:2]][15]}},RAM[MemAddr[13:2]][15:8]};
			end
			else if(MemAddr[1:0] == 2'b10)begin
				dout = {{24{RAM[MemAddr[13:2]][23]}},RAM[MemAddr[13:2]][23:16]};
			end
			else begin
				dout = {{24{RAM[MemAddr[13:2]][31]}},RAM[MemAddr[13:2]][31:24]};
			end
		end
	endcase
end
always @(posedge clk)begin
	if(reset)begin
		for(i = 0;i < 3073;i = i+1)begin
			RAM[i] <= 0;
		end
	end
   else begin
        if (MemWrite == 1)begin
				case(DMOp)
					`DM_word: begin
						RAM[MemAddr[13:2]] <= din;
						$display("@%h: *%h <= %h", pc, MemAddr, din);
					end
					`DM_halfword:begin
						if(MemAddr[1] == 0)begin
							RAM[MemAddr[13:2]] = {RAM[MemAddr[13:2]][31:16],din[15:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {RAM[MemAddr[13:2]][31:16],din[15:0]});
						end
						else begin
							RAM[MemAddr[13:2]] = {din[15:0],RAM[MemAddr[13:2]][15:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {din[15:0],RAM[MemAddr[13:2]][15:0]});
						end
					end
					`DM_byte:begin
						if(MemAddr[1:0] == 2'b00)begin
							RAM[MemAddr[13:2]] = {RAM[MemAddr[13:2]][31:8],din[7:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {RAM[MemAddr[13:2]][31:8],din[7:0]});
						end
						else if(MemAddr[1:0] == 2'b01)begin
							RAM[MemAddr[13:2]] = {RAM[MemAddr[13:2]][31:16],din[7:0],RAM[MemAddr[13:2]][7:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {RAM[MemAddr[13:2]][31:16],din[7:0],RAM[MemAddr[13:2]][7:0]});
						end
						else if(MemAddr[1:0] == 2'b10)begin
							RAM[MemAddr[13:2]] = {RAM[MemAddr[13:2]][31:24],din[7:0],RAM[MemAddr[13:2]][15:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {RAM[MemAddr[13:2]][31:24],din[7:0],RAM[MemAddr[13:2]][15:0]});
						end
						else begin
							RAM[MemAddr[13:2]] = {din[7:0],RAM[MemAddr[13:2]][23:0]};
							$display("@%h: *%h <= %h", pc, MemAddr, {din[7:0],RAM[MemAddr[13:2]][23:0]});
						end
					end
				endcase
				
        end
    end
end
//assign dout = RAM[MemAddr[13:2]];
endmodule
