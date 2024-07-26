`timescale 1ns / 1ps

`define dm_start 32'h0000
`define dm_end 32'h2fff
`define t0_start 32'h7f00
`define t0_end 32'h7f0b
`define t1_start 32'h7f10
`define t1_end 32'h7f1b
`define zd_start 32'h7f20
`define zd_end 32'h7f23


module Bridge(
	input [31:0] CPU_DM_addr,
	input [3:0] CPU_DM_byteen,
	input [31:0] DM_rdata,
	input [31:0] TC0_Dout,
	input [31:0] TC1_Dout,
	
	
	
	output [31:0] CPU_DM_rdata,
	output [31:0] DM_Addr,
	output [3:0] DM_byteen,
	output [31:2] TC0_Addr,
	output [31:2] TC1_Addr,
	output TC0_WE,
	output TC1_WE,
	output [31:0] Int_Addr,
	output [3:0] Int_byteen
    );

assign CPU_DM_rdata = (CPU_DM_addr >= `dm_start && CPU_DM_addr <= `dm_end) ? DM_rdata:
						    (CPU_DM_addr >= `t0_start && CPU_DM_addr <= `t0_end) ? TC0_Dout:
						    (CPU_DM_addr >= `t1_start && CPU_DM_addr <= `t1_end) ? TC1_Dout:
							 32'd0;
							 
assign DM_Addr =	CPU_DM_addr;
assign DM_byteen = (CPU_DM_addr >= `dm_start && CPU_DM_addr <= `dm_end) ? CPU_DM_byteen : 4'd0;


assign TC0_Addr = CPU_DM_addr[31:2];				 
assign TC1_Addr = CPU_DM_addr[31:2];

assign TC0_WE = (CPU_DM_addr >= `t0_start) && (CPU_DM_addr <= `t0_end) &&(|CPU_DM_byteen);
assign TC1_WE = (CPU_DM_addr >= `t1_start) && (CPU_DM_addr <= `t1_end) &&(|CPU_DM_byteen);
				 
assign Int_Addr = CPU_DM_addr;
assign Int_byteen = (CPU_DM_addr == 32'h7f20) ? CPU_DM_byteen : 4'd0;

endmodule
