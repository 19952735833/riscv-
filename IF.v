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
// 瀹炵幇pc鍔熻兘 锛屽叾浠栧姛鑳戒娇鐢ㄥ瓙妯″潡

module IF(
	input clk,
	input rst_n,
	input[31:0] input_pc,
	input input_PCSrc,
	input pc_nop_control,
	input pc_stop,
	output[31:0] pc,
	output reg ce
    );
reg[31:0] pc_copy;
reg[31:0] pc_reserve;
reg i;
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        i <= 1'b0;
        ce <= 1'b0;
        pc_reserve[31:0] <= 32'h0000_0000;
        pc_copy[31:0] <= 32'h0000_0000;
     end
     else begin
        if(i)begin
            pc_copy[31:0] <= 32'h0000_0000;
            i <= 1'b0;
        end 
        else begin
        i <= 1'b0;
        ce <= 1'b1;
        pc_reserve = pc_reserve + 4; 
        pc_copy <= pc_reserve;
        end
    end
end
// 这用上升沿 因为 不可能连续停顿两次 可能与上边冲突
always @(posedge pc_stop)begin
    pc_reserve = pc_reserve - 4;
    pc_copy[31:0] <= pc_reserve;
end 
// 这也一样， 因为 beq指令后边是nop  会变成低电平
always @(posedge pc_nop_control)begin
    pc_copy[31:0] <= 32'h0000_0000;
    i <= 1'b1;
end
wire[31:0] pc_wire = pc_copy;
wire[31:0] pc_;
MUX MUX0(
	//.clk(clk),
	.rst_n(rst_n),
	.input_data0(pc_wire),
	.input_data1(input_pc),
	.input_control(input_PCSrc),
	.output_data(pc_)
);
//always @(negedge rst_n)begin		//澶嶄綅
//		pc_copy[31:0] <= 32'h0000_0000;
//end
assign pc = pc_;
endmodule
