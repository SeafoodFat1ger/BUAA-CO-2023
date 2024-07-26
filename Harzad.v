`timescale 1ns / 1ps

module Harzad(
    input [31:0] D_Grs,
    input [31:0] D_Grt,
	 input [31:0] E_Grs,
    input [31:0] E_Grt,
    input [31:0] M_Grt,

    input [4:0] D_rs,
    input [4:0] D_rt,
	 input [4:0] E_rs,
    input [4:0] E_rt,
    input [4:0] M_rt,

	 
    input [4:0] E_A3,
    input [4:0] M_A3,
    input [4:0] W_A3,
	 
    input [2:0] D_Tuse_rs,
    input [2:0] D_Tuse_rt,
	 
    input [2:0] E_Tnew,
    input [2:0] M_Tnew,
    input [2:0] W_Tnew,
	 
    input [31:0] E_out,
    input [31:0] M_out,
    input [31:0] W_out,
	 
	 
	 input E_RegWrite,
	 input M_RegWrite,
	 input W_RegWrite,
	 
	 
	 input D_isMDFT,
	 input E_MD_busy,
	 input E_MD_start,
	 
	 input D_is_eret,
	 input E_is_mtc0,
	 input M_is_mtc0,
	 input [4:0] E_rd,
	 input [4:0] M_rd,
	 
    output [31:0] D_Fw_Grs,
    output [31:0] D_Fw_Grt,
    output [31:0] E_Fw_Grs,
    output [31:0] E_Fw_Grt,
    output [31:0] M_Fw_Grt,
	 
	 output stall
    );

/////////////////stall//////////////////////////////////
wire Stall_rs_E = (D_Tuse_rs < E_Tnew) && (D_rs == E_A3) && (D_rs != 5'd0)&&(E_RegWrite == 1'b1);
wire Stall_rs_M = (D_Tuse_rs < M_Tnew) && (D_rs == M_A3) && (D_rs != 5'd0)&&(M_RegWrite == 1'b1);
wire Stall_rt_E = (D_Tuse_rt < E_Tnew) && (D_rt == E_A3) && (D_rt != 5'd0)&&(E_RegWrite == 1'b1);
wire Stall_rt_M = (D_Tuse_rt < M_Tnew) && (D_rt == M_A3) && (D_rt != 5'd0)&&(M_RegWrite == 1'b1);

wire Stall_MD_E = (D_isMDFT && (E_MD_start || E_MD_busy));

wire Stall_eret = (D_is_eret) && ((E_is_mtc0 && E_rd == 5'd14) || (M_is_mtc0 && M_rd == 5'd14));

assign stall = Stall_eret || Stall_MD_E || Stall_rs_E || Stall_rs_M || Stall_rt_E || Stall_rt_M;



////////////////////forward///////////////////
assign D_Fw_Grs = (D_rs == E_A3 && D_rs != 5'd0 && E_RegWrite == 1'b1)?E_out:
						(D_rs == M_A3 && D_rs != 5'd0 && M_RegWrite == 1'b1)?M_out:						
						D_Grs;
assign D_Fw_Grt = (D_rt == E_A3 && D_rt != 5'd0 && E_RegWrite == 1'b1)?E_out:
						(D_rt == M_A3 && D_rt != 5'd0 && M_RegWrite == 1'b1)?M_out:						
						D_Grt;
assign E_Fw_Grs = (E_rs == M_A3 && E_rs != 5'd0 && M_RegWrite == 1'b1)?M_out:
						(E_rs == W_A3 && E_rs != 5'd0 && W_RegWrite == 1'b1)?W_out:						
						E_Grs;
assign E_Fw_Grt = (E_rt == M_A3 && E_rt != 5'd0 && M_RegWrite == 1'b1)?M_out:
						(E_rt == W_A3 && E_rt != 5'd0 && W_RegWrite == 1'b1)?W_out:						
						E_Grt;

assign M_Fw_Grt = (M_rt == W_A3 && M_rt != 5'd0 && W_RegWrite == 1'b1)?W_out:						
						M_Grt;


endmodule
