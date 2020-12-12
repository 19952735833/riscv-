`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 13:46:47
// Design Name: 
// Module Name: Regfile
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


module Regfile(
	input clk,
	input res_n,
	input reg_write,
	//input[31:0] write_reg_data,
	input[4:0] write_reg_addr,
	input reg_control,
	input[4:0] read_reg0_addr,
	input[4:0] read_reg1_addr,
	output reg[31:0] read_reg0_data,
	output reg[31:0] read_reg1_data
    );

reg[31:0] reg_mem[0:31];

always @ (posedge clk or negedge res_n)begin
	if(~res_n)begin
		read_reg0_data[31:0] <= 32'h0000_0000;
		read_reg1_data[31:0] <= 32'h0000_0000;
	end
	else begin 
		if(reg_control && reg_write)begin  // 如果是1 不读第二个寄存器
			read_reg0_data <= reg_mem[read_reg0_addr[4:0]];
		end
		else if(~control && reg_write)begin
			read_reg0_data <= reg_mem[read_reg0_addr[4:0]];			//这种写法对吗？
			read_reg1_data <= reg_mem[read_reg1_addr[4:0]];
		end
		//else  需要报错
		if(reg_write)begin
			reg_mem[write_reg_addr[4:0]] <= write_reg_data;
		end
	end
end
endmodule
