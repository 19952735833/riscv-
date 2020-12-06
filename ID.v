`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 16:41:34
// Design Name: 
// Module Name: ID
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


module ID(
	input clk,
	input res_n,
	input[31:0] instruction,
	output reg[7:0] id_ex_control,
	output reg[31:0] id_ex0,
	output reg[31:0] id_ex1
	);

initial begin
	reg[7:0] temp <= instruction[7:2];			//这样赋值是否可行？  即 temp = 000 01100
end

always @ (posedge clk or negedge res_n)begin
	if(~res_n)begin
		id_ex_control <= 8'b0;
		id_ex0 <= 32'b0;
		id_ex1 <= 32'b0;
	end
	else begin
		case(temp)
			8'00001100:begin
				


endmodule
