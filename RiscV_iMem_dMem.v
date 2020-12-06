`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 08:51:56
// Design Name: 
// Module Name: RiscV_iMem_dMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 32位数据宽度，指令宽度
// 数据和指令内存： 2^8 * 32bit
// top一级方法，设置risc输入和指令存储器，数据存储器

module RiscV_iMem_dMem(
	input clk,
	input rst_n
    );
wire[31:0] d_datain;
wire[31:0] d_dataout;
wire[31:0] i_datain;
wire mem_writeBack;		//存储器写回控制
wire mem_write; //存储器写控制
wire[7:0] d_addr;
wire[7:0] i_addr;

RiscV RiscV0(
	clk(clk),
	rst_n(rst_n),
	d_datain(d_datain),
	i_datain(i_datain),
	d_dataout(d_dataout),
	i_addr(i_addr),
	d_addr(d_addr),
	mem_write(mem_write),
	mem_writeBack(mem_writeBack)
);
InstructionMem InstructionMem0(
	i_addr(i_addr),
	i_data(i_datain),		//在指令存储器，使用i_data
);
DataMem DataMem0(		//先不加时钟控制
	mem_write(mem_write),
	mem_writeBack(mem_writeBack),	//写回控制位
	d_addr(d_addr),
	dw_data(d_dataout),	//在数据存储器使用 dw_data dr_data
	dr_data(d_datain)
);

endmodule
