`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/15 22:10:08
// Design Name: 
// Module Name: REG_EX_MEM
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


module REG_EX_MEM(
    input clk,
    input rst_n,
    input[31:0] f_ex_pc,
    input[4:0] f_ex_reg_addr,
    input[7:0] f_ex_control,
    input[31:0] f_ex_ALU_result,
    input[31:0] f_ex_write_data,
    input f_ex_zero_flag,
   // input pc_stop,
    //output reg pc_continue,
    output reg[31:0] t_mem_pc,
    output reg[4:0] t_mem_reg_addr,
    output reg pro_control,
    output reg[7:0] t_mem_control,
    output reg[31:0] t_mem_ALU_result,
    output reg[31:0] t_mem_write_data,
    output reg t_mem_zero_flag
    );
//always @(negedge pc_stop)begin
//    pc_continue <= 1'b1;
//end
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        pro_control <= 1'b0;
        t_mem_pc <= {32{1'b0}};
        t_mem_reg_addr <= {5{1'b0}};
        t_mem_control <= {8{1'b0}};
        t_mem_ALU_result <= {32{1'b0}};
        t_mem_write_data <= {32{1'b0}};
        t_mem_zero_flag <= 1'b0;
        //pc_continue <= 1'b0;
    end
    else begin
//        if(pc_stop)begin
//            pc_continue = 1'b1;
//        end
        
        //pc_continue <= 1'b0;
        pro_control <= f_ex_control[1]; //   1 Îª RÐÍÖ¸Áî  0  I type
        t_mem_pc <= f_ex_pc;
        t_mem_reg_addr <= f_ex_reg_addr;
        t_mem_control <= f_ex_control;
        t_mem_ALU_result <= f_ex_ALU_result;
        t_mem_write_data <= f_ex_write_data;
        t_mem_zero_flag <= f_ex_zero_flag;
    end
end
endmodule
