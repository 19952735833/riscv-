`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/15 23:08:56
// Design Name: 
// Module Name: REG_MEM_WB
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


module REG_MEM_WB(
    input clk,
    input rst_n,
    input[4:0] f_mem_reg_addr,
    input[7:0] f_mem_control,
    input[31:0] f_mem_memdata,
    input[31:0] f_mem_regdata,
    output reg[4:0] t_wb_reg_addr,
    output reg[7:0] t_wb_control,
    output reg[31:0] t_wb_memdata,
    output reg[31:0] t_wb_regdata
    );
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        t_wb_reg_addr <= {5{1'b0}};
        t_wb_control <= {8{1'b0}};
        t_wb_memdata <= {32{1'b0}};
        t_wb_regdata <= {32{1'b0}};
    end
    else begin
        t_wb_reg_addr <= f_mem_reg_addr;
        t_wb_control <= f_mem_control;
        t_wb_memdata <= f_mem_memdata;
        t_wb_regdata <= f_mem_regdata;
    end
end
endmodule
