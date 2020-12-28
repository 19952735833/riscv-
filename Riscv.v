`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 16:36:34
// Design Name: 
// Module Name: Riscv
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


module Riscv(
    input clk,
    input rst_n,
    output[31:0] instruction
    );
wire[31:0] inst_addr;
wire[31:0] inst;
wire rom_ce;
assign instruction = inst;
RiscV_iMem_dMem RiscV_iMem_dMem0(
    .clk(clk),
    .rst_n(rst_n),
    .i_data(inst),
    .i_addr(inst_addr),
    .ce(rom_ce)
);

InstructionMem Instruction0(
    .rst_n(rom_ce),
    .i_addr(inst_addr),
    .i_data(inst)
);
endmodule
