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
    input rst_n, 
	input[31:0] i_addr,
	output reg[31:0] i_data
    );
reg[7:0] instruction_mem[0:63];  //wire 类型 ？？？ 还是reg
initial $readmemh ("instuction.data", instruction_mem);

always @(*)begin
    if(~rst_n)
        i_data <= {32{1'b0}};
    else
        i_data <= {instruction_mem[i_addr],instruction_mem[i_addr+1],instruction_mem[i_addr+2],instruction_mem[i_addr+3]}; 
end 

endmodule
