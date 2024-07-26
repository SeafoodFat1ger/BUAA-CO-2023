`timescale 1ns / 1ps
`include <define.v>

module BE(
	input [31:0] MemAddr,
	input [31:0] din,
	input [2:0] BEOp,
	output reg [31:0] m_data_wdata,
	output reg [3:0] m_data_byteen
    );

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
endmodule
