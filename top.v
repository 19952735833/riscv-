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

//每20ps翻转一次  100ps重置
//top方法，设置时钟

//标准：module 有关联的使用驼峰式命名，并列的使用’_‘连接
//		实例统一用 module名加阿拉伯数字
module top(
	
    );
reg clk;
//reg enable;
reg rst_n;
//reg start;

initial begin
	clk = 1'b0;
	rst_n = 1'b1;
	#100
	rst_n = 1'b0;
end

always #20 clk = ~clk;

RiscV_iMem_dMem RiscV_iMem_dMem0(
	.clk(clk),
	.rst_n(rst_n)	
);

endmodule
