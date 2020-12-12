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
// 数据和指令内存： 2^8 * 8bit
// top一级方法，设置risc输入和指令存储器，数据存储器

module RiscV_iMem_dMem(
	input clk,
	input rst_n
    );
wire[31:0] d_datain;
wire[31:0] d_dataout;
wire[7:0] d_addr;

	reg[31:0] if_id;
	//  pc 在各个流水线寄存器中传递 ，可以在IF阶段修改 省出流水线寄存器空间
	reg[31:0] if_id_pc;
	reg[31:0] id_ex_pc;
	reg[31:0] ex_mem_pc;

	reg[31:0] id_ex0;		// read data 1   p199
	reg[31:0] id_ex1;		// read data 2
	reg[7:0] id_ex_control; // p179   图4-18
	reg[31:0] id_ex_imm;	// imm Gen
	reg[3:0] id_ex_ALU_control;   // instruction[30, 14:12]

	reg[31:0] ex_mem_ALU_result;
	reg[31:0] ex_mem_write_data;
	reg[7:0] ex_mem_control;
	reg ex_mem_zero_flag;

	reg[31:0] mem_wb_memdata;
	reg[31:0] mem_wb_regdata;
	reg[31:0] mem_wb_pc;
	reg[7:0] mem_wb_control;
	reg mem_wb_PCSrc_flag;

IF IF0(			//暂时无分支跳转指令
	clk(clk),
	res_n(res_n),
	input_pc(mem_wb_pc),
	input_PCSrc(mem_wb_PCSrc_flag),
	if_id(if_id),
	if_id_pc(if_id_pc)
);

ID ID0(
	clk(clk),
	res_n(res_n),
	instruction(if_id),
	if_id_pc(if_id_pc),		// 从if/id寄存器读
	id_ex_pc(id_ex_pc),
	id_ex_control(id_ex_control),   
	id_ex0(id_ex0),
	id_ex1(id_ex1),
	id_ex_imm(id_ex_imm),
	id_ex_ALU_control(id_ex_ALU_control)    // 输出到id/ex寄存器
);
/* 从这起 ， 改变了下命名规则 */
EX EX0(   
	clk(clk),
	res_n(res_n),
	input_reg0(id_ex0),
	input_reg1(id_ex1),
	input_imm(id_ex_imm),	
	input_control(id_ex_control),
	input_ALU_control(id_ex_ALU_control),	
	input_pc(id_ex_pc),	
	ex_mem_control(ex_mem_control),								//从id/ex寄存器读
	ex_mem_pc(ex_mem_pc),
	ex_mem_ALU_result(ex_mem_ALU_result),
	ex_mem_write_data(ex_mem_write_data),
	zero_flag(ex_mem_zero_flag)				//输出到ex/mem寄存器
);

MEM MEM0(
	clk(clk),
	res_n(res_n),
	input_pc(ex_mem_pc),
	input_zero_flag(ex_mem_zero_flag),
	input_addr(ex_mem_ALU_result),
	input_data(ex_mem_write_data),
	input_control(ex_mem_control),
	mem_wb_control(mem_wb_control),
	mem_wb_memdata(mem_wb_memdata),
	mem_wb_regdata(mem_wb_regdata),
	mem_wb_pc(mem_wb_pc),
	PCSrc_flag(mem_wb_PCSrc_flag)
);


WB WB0(
	clk(clk),
	res_n(res_n),
	input_memdata(mem_wb_memdata),
	input_regdata(mem_wb_regdata),
	input_control(mem_wb_control),
	
);

endmodule
