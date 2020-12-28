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
	input rst_n,
	input[31:0] instruction,
	input[6:0] control,
	output[31:0] imm
    );
reg[31:0] imm_copy;
always @(*)begin
	if(~rst_n)begin
		imm_copy[31:0] <= 32'h0000_0000;
	end
	else begin
		case(control)
		    7'b0110011: begin
		        imm_copy <= 32'h0000_0000;
		    end
			7'b0000011: begin
				imm_copy[31:0] <= {{21{instruction[31]}}, instruction[30:20]};
			end
			7'b0100011: begin
				imm_copy[31:0] <= {{21{instruction[31]}}, instruction[30:25],instruction[11:7]};
			end
			7'b1100011: begin   // branch    书上�? 12 �? 0   是不是左移后的？
				imm_copy[31:0] <= {{19{instruction[31]}}, instruction[7],instruction[30:25],instruction[11:8],{2'b00}};
			end
		endcase
	end
end
assign imm = imm_copy;
endmodule
