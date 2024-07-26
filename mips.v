`timescale 1ns / 1ps

module mips(
    input clk,                    // ʱ���ź�
    input reset,                  // ͬ����λ�ź�
    input interrupt,              // �ⲿ�ж��ź�
    output [31:0] macroscopic_pc, // ��� PC

    output [31:0] i_inst_addr,    // IM ��ȡ��ַ��ȡָ PC��
    input  [31:0] i_inst_rdata,   // IM ��ȡ����

    output [31:0] m_data_addr,    // DM ��д��ַ
    input  [31:0] m_data_rdata,   // DM ��ȡ����
    output [31:0] m_data_wdata,   // DM ��д������
    output [3 :0] m_data_byteen,  // DM �ֽ�ʹ���ź�

    output [31:0] m_int_addr,     // �жϷ�������д���ַ
    output [3 :0] m_int_byteen,   // �жϷ������ֽ�ʹ���ź�

    output [31:0] m_inst_addr,    // M �� PC

    output w_grf_we,              // GRF дʹ���ź�
    output [4 :0] w_grf_addr,     // GRF ��д��Ĵ������
    output [31:0] w_grf_wdata,    // GRF ��д������

    output [31:0] w_inst_addr     // W �� PC
);


wire [31:0] CPU_DM_rdata,CPU_DM_addr,CPU_DM_wdata;
wire [3:0] CPU_DM_byteen;

wire [31:0] TC0_Dout,TC1_Dout;
wire [31:2] TC0_Addr,TC1_Addr;
wire TC0_WE,TC1_WE;
wire TC0_IRQ,TC1_IRQ;

wire [5:0] HWInt = {3'b0, interrupt, TC1_IRQ, TC0_IRQ};


cpu CPU(
	.clk(clk),
	.reset(reset),
	.HWInt(HWInt),
	.CPU_inst_rdata(i_inst_rdata),
	.CPU_DM_rdata(CPU_DM_rdata),
	
	
	.CPU_inst_addr(i_inst_addr),
	.CPU_DM_addr(CPU_DM_addr),
	.CPU_DM_wdata(CPU_DM_wdata),
	.CPU_DM_byteen(CPU_DM_byteen),
	.PC_M(m_inst_addr),
	.CPU_w_grf_we(w_grf_we),
	.CPU_w_grf_addr(w_grf_addr),
	.CPU_w_grf_wdata(w_grf_wdata),
	.PC_W(w_inst_addr),
	.PC_macro(macroscopic_pc)

);

assign m_data_wdata = CPU_DM_wdata;

Bridge Bridge(
	.CPU_DM_addr(CPU_DM_addr),
	.CPU_DM_byteen(CPU_DM_byteen),
	.DM_rdata(m_data_rdata),
	.TC0_Dout(TC0_Dout),
	.TC1_Dout(TC1_Dout),
	
	
	.CPU_DM_rdata(CPU_DM_rdata),
	.DM_Addr(m_data_addr),
	.DM_byteen(m_data_byteen),
	.TC0_Addr(TC0_Addr),
	.TC1_Addr(TC1_Addr),
	.TC0_WE(TC0_WE),
	.TC1_WE(TC1_WE),
	.Int_Addr(m_int_addr),
	.Int_byteen(m_int_byteen)
);



TC TC0(
	.clk(clk),
	.reset(reset),
	.Addr(TC0_Addr),
	.WE(TC0_WE),
	.Din(CPU_DM_wdata),
	.Dout(TC0_Dout),
	.IRQ(TC0_IRQ)
	
);

TC TC1(
	.clk(clk),
	.reset(reset),
	.Addr(TC1_Addr),
	.WE(TC1_WE),
	.Din(CPU_DM_wdata),
	.Dout(TC1_Dout),
	.IRQ(TC1_IRQ)
	
);

endmodule
