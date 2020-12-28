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
// top�?级方法，设置risc输入和指令存储器，数据存储器

module RiscV_iMem_dMem(
	input clk,
	input rst_n,
	input[31:0] i_data,
	output[31:0] i_addr,
	output ce
    );
wire[31:0] d_datain;
wire[31:0] d_dataout;
wire[7:0] d_addr;

	wire[31:0] t_ins;
	//  pc 在各个流水线寄存器中传�?? ，可以在IF阶段修改 省出流水线寄存器空间
	wire[31:0] f_if_pc;
	wire[31:0] t_id_pc;
	wire[31:0] f_id_pc,t_ex_pc;
	wire[31:0] f_ex_pc,t_mem_pc;

    wire[4:0] f_id_reg_addr,t_ex_reg_addr;
	wire[31:0] f_id0,t_ex0;		// read data 1   p199
	wire[31:0] f_id1,t_ex1;		// read data 2
	wire[7:0] f_id_control,t_ex_control; // p179   �?4-18
	wire[31:0] f_id_imm,t_ex_imm;	// imm Gen
	wire[3:0] f_id_ALU_control,t_ex_ALU_control;   // instruction[30, 14:12]

    wire[4:0] f_ex_reg_addr,t_mem_reg_addr;
	wire[31:0] f_ex_ALU_result,t_mem_ALU_result;
	wire[31:0] f_ex_write_data,t_mem_write_data;
	wire[7:0] f_ex_control,t_mem_control;
	wire f_ex_zero_flag,t_mem_zero_flag;

    wire[4:0] f_mem_reg_addr,t_wb_reg_addr;
	wire[31:0] f_mem_memdata,t_wb_memdata;
	wire[31:0] f_mem_regdata,t_wb_regdata;
	wire[31:0] f_mem_pc,t_wb_pc;
	wire[7:0] f_mem_control,t_wb_control;
	wire f_mem_PCSrc_flag,t_wb_PCSrc_flag;
	
	wire[4:0] wb_single;
	wire[31:0] wb_data;
	wire wb_control;
	
	wire pc_nop_control;
	wire pc_stop;
	wire pc_continue;

IF IF0(			//暂时无分支跳转指�?
	.clk(clk),
	.rst_n(rst_n),
	.input_pc(f_mem_pc),
	.input_PCSrc(f_mem_PCSrc_flag),
	.pc_nop_control(pc_nop_control),
	.pc_stop(pc_stop),
	.pc(f_if_pc),
	.ce(ce)
);
assign i_addr = f_if_pc;
REG_IF_ID REG_IF_ID0(
    .clk(clk),
    .rst_n(rst_n),
    .f_if_pc(f_if_pc),
    .f_if_ins(i_data),
    .pc_stop(pc_stop),
   // .pc_continue(pc_continue),
    .t_id_pc(t_id_pc),
    .t_id_ins(t_ins)
);
wire[4:0] f_id0_addr,t_ex0_addr;
wire[4:0] f_id1_addr,t_ex1_addr;
ID ID0(
	.rst_n(rst_n),
	.instruction(t_ins),   // 
	.input_wb_single(wb_single),
	.input_wb_data(wb_data),
	.input_wb_control(wb_control),
	.input_pc(t_id_pc),		// 从if/id寄存器读
	.t_ex_pc(f_id_pc),
	.t_ex_control(f_id_control),   
	.id0(f_id0),
	.id1(f_id1),
	.id0_addr(f_id0_addr),
	.id1_addr(f_id1_addr),
	.id_imm(f_id_imm),
	.t_ex_ALU_control(f_id_ALU_control),    // 输出到id/ex寄存�?
	.t_ex_reg_addr(f_id_reg_addr),
	.pc_nop_control(pc_nop_control)
);

REG_ID_EX REG_ID_EX0(
    .clk(clk),
    .rst_n(rst_n),
    .f_id_pc(f_id_pc),
    .f_id0(f_id0),
    .f_id1(f_id1),
    .f_id_imm(f_id_imm),
    .f_id_ALU_control(f_id_ALU_control),
    .f_id_control(f_id_control),
    .f_id_reg_addr(f_id_reg_addr),
    .f_id0_addr(f_id0_addr),
    .f_id1_addr(f_id1_addr),
    .pc_stop(pc_stop),
   // .pc_continue(pc_continue),
        .t_ex0_addr(t_ex0_addr),
        .t_ex1_addr(t_ex1_addr),
    .    t_ex_pc(t_ex_pc),
        .t_ex0(t_ex0),
        .t_ex1(t_ex1),
        .t_ex_imm(t_ex_imm),
        .t_ex_ALU_control(t_ex_ALU_control),
        .t_ex_control(t_ex_control),
        .t_ex_reg_addr(t_ex_reg_addr)

);
// ��Щֵ���ݸ�EX�ȵȲ�û�б�Ҫ ��pc��ֱ�Ӵ�����ˮ�߼Ĵ�������  
wire pro_control;
EX EX0(   
	.rst_n(rst_n),
	.input_reg0(t_ex0),
	.input_reg1(t_ex1),
	.input_imm(t_ex_imm),	
	.input_control(t_ex_control),
	.input_ALU_control(t_ex_ALU_control),	
	.input_pc(t_ex_pc),
	.input_reg_addr(t_ex_reg_addr),
	.input_reg0_addr(t_ex0_addr),
	.input_reg1_addr(t_ex1_addr),
	   .input_pro_control(pro_control),
	   .input_expro_addr(t_mem_reg_addr),
	   .input_mempro_addr(wb_single),
	   .input_expro_data(t_mem_ALU_result),
	   .input_mempro_data(wb_data),  //����ǰ��,
	.t_mem_reg_addr(f_ex_reg_addr),	
	.t_mem_control(f_ex_control),								//从id/ex寄存器读
	.t_mem_pc(f_ex_pc),
	.t_mem_ALU_result(f_ex_ALU_result),
	.t_mem_write_data(f_ex_write_data),
	.zero_flag(f_ex_zero_flag),
	.pc_stop(pc_stop)				//输出到ex/mem寄存�?
);
REG_EX_MEM REG_EX_MEM0(
    .clk(clk),
    .rst_n(rst_n),
    .f_ex_pc(f_ex_pc),
    .f_ex_reg_addr(f_ex_reg_addr),
    .f_ex_control(f_ex_control),
    .f_ex_ALU_result(f_ex_ALU_result),
    .f_ex_write_data(f_ex_write_data),
    .f_ex_zero_flag(f_ex_zero_flag),
   // .pc_stop(pc_stop),
     //   .pc_continue(pc_continue),
        .t_mem_pc(t_mem_pc),
        .t_mem_reg_addr(t_mem_reg_addr),
        .t_mem_control(t_mem_control),
        .pro_control(pro_control),
        .t_mem_ALU_result(t_mem_ALU_result),
        .t_mem_write_data(t_mem_write_data),
        .t_mem_zero_flag(t_mem_zero_flag) 
);

MEM MEM0(
    .rst_n(rst_n),
	.input_pc(t_mem_pc),
	.input_zero_flag(t_mem_zero_flag),
	.input_addr(t_mem_ALU_result),
	.input_data(t_mem_write_data),
	.input_control(t_mem_control),
	.input_reg_addr(t_mem_reg_addr),
	.t_wb_reg_addr(f_mem_reg_addr),
	.t_wb_control(f_mem_control),
	.t_wb_memdata(f_mem_memdata),
	.t_wb_regdata(f_mem_regdata),
	.t_wb_pc(f_mem_pc),
	.PCSrc_flag(f_mem_PCSrc_flag)
);

REG_MEM_WB REG_MEM_WB0(
    .clk(clk),
    .rst_n(rst_n),
    .f_mem_reg_addr(f_mem_reg_addr),
    .f_mem_control(f_mem_control),
    .f_mem_memdata(f_mem_memdata),
    .f_mem_regdata(f_mem_regdata),
        .t_wb_reg_addr(t_wb_reg_addr),
        .t_wb_control(t_wb_control),
        .t_wb_memdata(t_wb_memdata),
        .t_wb_regdata(t_wb_regdata)
);


WB WB0(
	.rst_n(rst_n),
	.input_memdata(t_wb_memdata),
	.input_regdata(t_wb_regdata),
	.input_control(t_wb_control),
	.input_reg_addr(t_wb_reg_addr),
	.wb_single(wb_single),
	.wb_data(wb_data),
	.wb_control(wb_control)
);

endmodule
