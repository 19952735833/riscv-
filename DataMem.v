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
// 此处没有 178�? MemtoReg 多路选择�?
module DataMem(
    input rst_n,
	input input_write_flag, 
	input input_read_flag,
	input[31:0] input_addr,
	input[31:0] input_data,
	output reg[31:0] dr_data
    );

reg[31:0] data_mem[0:255];

//initial $readmemh
always @(negedge rst_n)begin
    dr_data <= {32{1'b0}};
end
always @ (posedge input_read_flag) begin
	dr_data <= data_mem[input_addr[31:0]];
end
// 四大基本指令 不可能出�? mem_writeBack �? mem_write 同时上升沿，即d_addr不会冲突
always @ (posedge input_write_flag)begin
	data_mem[input_addr[31:0]] <= input_data[31:0];
end

endmodule
