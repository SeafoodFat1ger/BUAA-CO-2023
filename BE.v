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

module BE(
	input [31:0] MemAddr,
	input [31:0] din,
	input Req,
	input M_Exc_Ovstore,
	input [2:0] BEOp,
	output reg [31:0] m_data_wdata,
	output reg [3:0] m_data_byteen,
	output M_Exc_AdES
    );


wire is_store = (BEOp == `BE_word)||(BEOp == `BE_halfword)||(BEOp == `BE_byte);

wire byte_Err = (BEOp == `BE_word)?(MemAddr[1:0]!= 2'b00):
					(BEOp == `BE_halfword)?(MemAddr[0]!= 1'b0):1'b0;
					
wire range_Err = (MemAddr >= `dm_start && MemAddr <= `dm_end)||
					(MemAddr >= `t0_start && MemAddr <= `t0_end)||
					(MemAddr >= `t1_start && MemAddr <= `t1_end)||
					(MemAddr >= `zd_start && MemAddr <= `zd_end)? 1'b0:1'b1;


wire timer_Err = ((BEOp == `BE_byte)||(BEOp == `BE_halfword))&&
					((MemAddr >= `t0_start && MemAddr <= `t0_end)||(MemAddr >= `t1_start && MemAddr <= `t1_end))? 1'b1 : 1'b0;

wire count_Err = (MemAddr >= 32'h7f08 && MemAddr <= `t0_end)||
					(MemAddr >= 32'h7f18 && MemAddr <= `t1_end)? 1'b1:1'b0;

assign M_Exc_AdES = (is_store)&&(M_Exc_Ovstore || byte_Err || range_Err || timer_Err || count_Err);


///////////////////////////////////////////////////////////////////////////
					
always @(*)begin
	case(BEOp)
		`BE_word: begin
			m_data_wdata = din;
		end
		`BE_halfword:begin
			if(MemAddr[1] == 0)begin
				m_data_wdata = {{16{1'b0}},din[15:0]};
			end
			else begin
				m_data_wdata = {din[15:0],{16{1'b0}}};
			end
		end
		`BE_byte:begin
			if(MemAddr[1:0] == 2'b00)begin
				m_data_wdata = {{24{1'b0}},din[7:0]};
			end
			else if(MemAddr[1:0] == 2'b01)begin
				m_data_wdata = {{16{1'b0}},din[7:0],{{8'b0}}};
			end
			else if(MemAddr[1:0] == 2'b10)begin
				m_data_wdata = {{8{1'b0}},din[7:0],{16{1'b0}}};
			end
			else begin
				m_data_wdata = {din[7:0],{24{1'b0}}};
			end
		end
		default:begin
			m_data_wdata = 0;
		end
	endcase
end

always @(*)begin
	if(Req)begin
		m_data_byteen = 4'b0000;
	end
	else begin
		case(BEOp)
			`BE_word: begin
				m_data_byteen = 4'b1111;
			end
			`BE_halfword:begin
				if(MemAddr[1] == 0)begin
					m_data_byteen = 4'b0011;
				end
				else begin
					m_data_byteen  = 4'b1100;
				end
			end
			`BE_byte:begin
				if(MemAddr[1:0] == 2'b00)begin
					m_data_byteen = 4'b0001;
				end
				else if(MemAddr[1:0] == 2'b01)begin
					m_data_byteen = 4'b0010;
				end
				else if(MemAddr[1:0] == 2'b10)begin
					m_data_byteen = 4'b0100;
				end
				else begin
					m_data_byteen = 4'b1000;
				end
			end
			default:begin
				m_data_byteen = 4'b0000;
			end
		endcase
	end
end
endmodule
