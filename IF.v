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


module IF(
	input clk,
	input res_n,
	input[31:0] instruction,
	output reg[7:0] pc,    //i_addr
	output reg[31:0] if_id
    );



always @(posedge clk or negedge res_n)begin		//复位
	if(~res_n)begin
		if_id[31:0] <= 32'h0000_0000;
		pc[7:0] <= 8'h00;
	end
	else begin
		if_id[31:0] <= instruction[31:0];
		pc[7:0] <= pc[7:0] + 1;
	end
end


endmodule
