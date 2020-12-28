`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 08:42:12
// Design Name: 
// Module Name: top
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

//�?20ps翻转�?�?  100ps重置
//top方法，设置时�?

//标准：module 有关联的使用驼峰式命名，并列的使用�?�_‘连�?
//		实例统一�? module名加阿拉伯数�?
module top(
	
    );
reg clk;
//reg enable;
reg rst_n;
//reg start;

initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	#40
	rst_n = 1'b1;
end

always #20 clk = ~clk;

Riscv Riscv0(
	.clk(clk),
	.rst_n(rst_n)	
);

endmodule
