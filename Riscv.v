`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 10:28:18
// Design Name: 
// Module Name: RiscV
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


module RiscV(
	input clk,
	input res_n,
	input[31:0] d_datain,
	input[31:0] i_datain,
	output reg[31:0] d_dataout,
	output reg[7:0] i_addr,
	output reg[7:0] d_addr,
	output mem_write,
	output mem_writeBack
    );


	reg[31:0] if_id;  //初始化

	reg[31:0] id_ex0;
	reg[31:0] id_ex1;
	reg[7:0] id_ex_control;

IF IF0(			//暂时无分支跳转指令
	clk(clk),
	res_n(res_n),
	instruction(i_datain),   // i_datain
	pc(i_addr),           // i_addr
	if_id(if_id)
);

ID ID0(
	clk(clk),
	res_n(res_n),
	instruction(if_id),
	id_ex_control(if_id_control),
	id_ex0(id_ex0),
	id_ex1(id_ex1)
);



endmodule
