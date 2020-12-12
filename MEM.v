`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 20:44:10
// Design Name: 
// Module Name: MEM
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


module MEM(
	input clk,
	input res_n,
	input[31:0] input_pc,
	input input_zero_flag,
	input[31:0] input_addr,			//也是ALU 计算的结果
	input[31:0] input_data,
	output reg[7:0] mem_wb_control,
	output reg[31:0] mem_wb_memdata,
	output reg[31:0] mem_wb_regdata,
	output reg[31:0] mem_wb_pc,
	output reg PCSrc_flag
    );

always @ (posedge clk or negedge res_n)begin
	if(~res_n)begin
		mem_wb_memdata[31:0] <= 32'h0000_0000;
		mem_wb_regdata[31:0] <= 32'h0000_0000;
		mem_wb_pc[31:0] <= 32'h0000_0000;
		mem_wb_control[7:0] <= 8'h00;
		PCSrc_flag <= 1'b0;
	end
	else begin
		mem_wb_regdata <= input_addr;
		mem_wb_pc <= input_pc;
		if(mem_wb_control[2] && input_zero_flag)begin
			PCSrc_flag <= 1'b1;
		end
		else begin
			PCSrc_flag <= 1'b0;
		end
	end
end
DataMem DataMem0(
	clk(clk),
	res_n(res_n),
	input_write_flag(mem_wb_control[3]),
	input_read_flag(mem_wb_control[4]),
	dr_data(mem_wb_memdata)
);
endmodule
