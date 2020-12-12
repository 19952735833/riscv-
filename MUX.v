`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 18:41:40
// Design Name: 
// Module Name: MUX
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


module MUX(
	input clk,
	input res_n,
	input[31:0] input_data0,
	input[31:0] input_data1,
	input input_control,
	output reg[31:0] output_data
    );

always @ (posedge clk or negedge res_n)begin
	if(~res_n)begin
		output_data[31:0] <= 32'h0000_0000;
	end
	else begin
		if(input_control)begin
			output_data[31:0] <= input_data1;
		end
		else begin
			output_data[31:0] <= input_data0;
		end
	end
end
endmodule
