`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 09:15:03
// Design Name: 
// Module Name: InstructionMem
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


module InstructionMem(
	input[7:0] i_addr,
	output reg[31:0] i_data
    );
reg[31:0] instruction_mem[0:255];

initial $readmemh ("Instuction.data", InstuctionMem);

always @ (*) begin
	i_data <= instruction_mem[i_addr[7:0]];
end
endmodule
