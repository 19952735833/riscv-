`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 10:49:53
// Design Name: 
// Module Name: IF
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
// 实现pc功能 ，其他功能使用子模块

module IF(
	input clk,
	input res_n,
	input input_pc,
	input input_PCSrc,
	output reg[31:0] if_id,
	output reg[31:0] if_id_pc
    );

reg[31:0] pc;  // 理论上 有 2^30个指令

always @(posedge clk or negedge res_n)begin		//复位
	if(~res_n)begin
		if_id[31:0] <= 32'h0000_0000;
		if_id_pc[31:0] <= 32'h0000_0000;
		//pc <= 32'h0000_0000;
	end
	else begin
		/*
		MUX MUX0(
			clk(clk),
			res_n(res_n),
			input_data0(pc + 4),
			input_data1(input_pc),
			input_control(input_PCSrc),
			output_data(pc)
		);
		*/
		pc <= pc + 4;   // 字节为单位
		if_id_pc <= pc;
	end
end

/* 指针存储器 */
InstructionMem InstructionMem0(
	clk(clk),
	res_n(res_n),
	i_addr(pc),
	i_data(if_id),		//在指令存储器，使用i_data
	);

endmodule
