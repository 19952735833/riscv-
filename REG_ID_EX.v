`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 23:22:19
// Design Name: 
// Module Name: REG_ID_EX
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


module REG_ID_EX(
    input clk,
    input rst_n,
    input[31:0] f_id_pc,
    input[31:0] f_id0,
    input[31:0] f_id1,
    input[31:0] f_id_imm,
    input[3:0] f_id_ALU_control,
    input[7:0] f_id_control,
    input[4:0] f_id_reg_addr,
    input[4:0] f_id0_addr,
    input[4:0] f_id1_addr,
    input pc_stop,
   // input pc_continue,
    output reg[4:0] t_ex0_addr,
    output reg[4:0] t_ex1_addr,
    output reg[31:0] t_ex_pc,
    output reg[31:0] t_ex0,
    output reg[31:0] t_ex1,
    output reg[31:0] t_ex_imm,
    output reg[3:0] t_ex_ALU_control,
    output reg[7:0] t_ex_control,
    output reg[4:0] t_ex_reg_addr
    );
reg[4:0] ex0_addr_resver;
reg[4:0] ex1_addr_resver;
reg[31:0] pc_resver;
reg[31:0] ex0_resver;
reg[31:0] ex1_resver;
reg[31:0] imm_resver;
reg[3:0] ALU_control_resver;
reg[7:0] control_resver;
reg[4:0] reg_addr_resver;

always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
    ex0_addr_resver <= {5{1'b0}};
    ex1_addr_resver <= {5{1'b0}};
    pc_resver <= {32{1'b0}};
    ex0_resver <= {32{1'b0}};
    ex1_resver <= {32{1'b0}};
    imm_resver <= {32{1'b0}};
    ALU_control_resver <= 4'h0;
    control_resver <= 8'b00; 
    reg_addr_resver <= 5'b00000;
        t_ex_pc <= {32{1'b0}};
        t_ex0 <= {32{1'b0}};
        t_ex1 <= {32{1'b0}};
        t_ex_imm <= {32{1'b0}};
        t_ex_ALU_control <= {4{1'b0}};
        t_ex_control <= {8{1'b0}};
        t_ex_reg_addr <= {5{1'b0}};
        t_ex0_addr <= {5{1'b0}};
        t_ex1_addr <= {5{1'b0}};
    end
    else begin
        if(pc_stop)begin
                                       t_ex0_addr = ex0_addr_resver[4:0];
                                       t_ex1_addr = ex1_addr_resver[4:0];
                                       t_ex_pc = pc_resver[31:0];
                                       t_ex0 = ex0_resver[31:0];
                                       t_ex1 = ex1_resver[31:0];
                                       t_ex_imm = imm_resver[31:0];
                                       t_ex_ALU_control = ALU_control_resver[3:0];
                                       t_ex_control = control_resver[7:0];
                                       t_ex_reg_addr = reg_addr_resver[4:0];
        end
//        else if(pc_continue)begin
//                       t_ex0_addr = ex0_addr_resver[4:0];
//                       t_ex1_addr = ex1_addr_resver[4:0];
//                       t_ex_pc = pc_resver[31:0];
//                       t_ex0 = ex0_resver[31:0];
//                       t_ex1 = ex1_resver[31:0];
//                       t_ex_imm = imm_resver[31:0];
//                       t_ex_ALU_control = ALU_control_resver[3:0];
//                       t_ex_control = control_resver[7:0];
//                       t_ex_reg_addr = reg_addr_resver[4:0];
//        ex0_addr_resver = f_id0_addr[4:0];
//        ex1_addr_resver = f_id1_addr[4:0];
//        pc_resver = f_id_pc[31:0];
//        ex0_resver = f_id0[31:0];
//        ex1_resver = f_id1[31:0];
//        imm_resver = f_id_imm[31:0];
//        ALU_control_resver = f_id_ALU_control[3:0];
//        control_resver = f_id_control[7:0];
//        reg_addr_resver = f_id_reg_addr[4:0];
//        end
        else begin
                ex0_addr_resver = f_id0_addr[4:0];
                ex1_addr_resver = f_id1_addr[4:0];
                pc_resver = f_id_pc[31:0];
                ex0_resver = f_id0[31:0];
                ex1_resver = f_id1[31:0];
                imm_resver = f_id_imm[31:0];
                ALU_control_resver = f_id_ALU_control[3:0];
                control_resver = f_id_control[7:0];
                reg_addr_resver = f_id_reg_addr[4:0];
                               t_ex0_addr = ex0_addr_resver[4:0];
                               t_ex1_addr = ex1_addr_resver[4:0];
                               t_ex_pc = pc_resver[31:0];
                               t_ex0 = ex0_resver[31:0];
                               t_ex1 = ex1_resver[31:0];
                               t_ex_imm = imm_resver[31:0];
                               t_ex_ALU_control = ALU_control_resver[3:0];
                               t_ex_control = control_resver[7:0];
                               t_ex_reg_addr = reg_addr_resver[4:0];
        end
    end
end
endmodule
