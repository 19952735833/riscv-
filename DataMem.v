`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 09:15:03
// Design Name: 
// Module Name: DataMem
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
//疑问：当收到ce 为低电平时，会不会有数据发过来？ 导致资源浪费
// 此处没有 178页 MemtoReg 多路选择器
module DataMem(
	input mem_write, 
	input mem_writeBack,
	input[7:0] d_addr,
	input[31:0] dw_data,
	output reg[31:0] dr_data
    );

reg[31:0] data_mem[0:255];

//initial $readmemh

always @ (posedge mem_writeBack) begin
	dr_data <= data_mem[d_addr[7:0]];
end
// 四大基本指令 不可能出现 mem_writeBack 和 mem_write 同时上升沿，即d_addr不会冲突
always @ (posedge mem_write)begin
	data_mem[d_addr[7:0]] <= dw_data[31:0];
end

endmodule
