`timescale 1ns / 1ps

module REG_IF_ID(
    input clk,
    input rst_n,
    input[31:0] f_if_pc,
    input[31:0] f_if_ins,
    input pc_stop,
//    input pc_continue,
    output reg[31:0] t_id_pc,
    output reg[31:0] t_id_ins
);
reg[31:0] pc_reserve;
reg[31:0] ins_reserve;
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        t_id_pc[31:0] <= 32'h0000_0000;
        t_id_ins[31:0] <= 32'h0000_0000;
        pc_reserve <= {32{1'b0}};
        ins_reserve <= {32{1'b0}};
    end
    else begin
        if(pc_stop)begin
            t_id_pc = pc_reserve[31:0];
            t_id_ins = ins_reserve[31:0];
            pc_reserve = f_if_pc[31:0];
            ins_reserve = f_if_ins[31:0];
        end
//        else if(pc_continue)begin
//            t_id_pc = pc_reserve[31:0];
//            t_id_ins = ins_reserve[31:0];
//            pc_reserve <= f_if_pc[31:0];
//            ins_reserve <= f_if_ins[31:0];
//        end
        else begin
            pc_reserve = f_if_pc[31:0];
            ins_reserve = f_if_ins[31:0];
            t_id_pc = pc_reserve[31:0];
            t_id_ins = ins_reserve[31:0];
        end
    end
end
endmodule