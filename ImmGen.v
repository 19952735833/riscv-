`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/08 17:09:05
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
	input clk,
	input res_n,
	input[31:0] instruction,
	input[7:0] control,
	output reg[31:0] imm
    );
always @(posedge clk or negedge res_n)begin
	if(~res_n)begin
		imm[31:0] <= 32'h0000_0000;
	end
	else begin
		case(control)
			8'b00000000: begin
				imm[31:0] <= {{21{instruction[31]}}, instruction[30:20]};
			end
			8'b00001000: begin
				imm[31:0] <= {{21{instruction[31]}}, instruction[30:25],instruction[11:7]};
			end
			8'b00011000: begin   // branch    书上说 12 ： 0   是不是左移后的？
				imm[31:0] <= {{21{instruction[31]}}, instruction[7],instruction[30:25],instruction[11:8]};
			end
		endcase
	end
end
endmodule
