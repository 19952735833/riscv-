`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 20:44:10
// Design Name: 
// Module Name: MEM
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


module MEM(
	input rst_n,
	input[31:0] input_pc,
	input input_zero_flag,
	input[31:0] input_addr,			//也是ALU 计算的结�?
	input[31:0] input_data,
	input[7:0] input_control,
	input[4:0] input_reg_addr,
	output[4:0] t_wb_reg_addr, 
	output[7:0] t_wb_control,
	output[31:0] t_wb_memdata,
	output[31:0] t_wb_regdata,
	output[31:0] t_wb_pc,
	output PCSrc_flag
    );
    reg[4:0] t_wb_reg_addr_copy; 
    reg[7:0] t_wb_control_copy;
    reg[31:0] t_wb_regdata_copy;
    reg[31:0] t_wb_pc_copy;
    reg PCSrc_flag_copy;
    reg[31:0] t_wb_memdata_copy;
always @ (*)begin
	if(~rst_n)begin
		t_wb_regdata_copy[31:0] <= 32'h0000_0000;
		t_wb_pc_copy[31:0] <= 32'h0000_0000;
		t_wb_control_copy[7:0] <= 8'h00;
		PCSrc_flag_copy <= 1'b0;
		t_wb_reg_addr_copy <= 5'b00000;
	end
	else begin
		t_wb_regdata_copy <= input_addr;
		t_wb_pc_copy <= input_pc;
		t_wb_reg_addr_copy <= input_reg_addr;
		t_wb_control_copy <= input_control;
		if(input_control[2] && input_zero_flag)begin
			PCSrc_flag_copy <= 1'b1;
		end
		else begin
			PCSrc_flag_copy <= 1'b0;
		end
	end
end

    assign t_wb_reg_addr = t_wb_reg_addr_copy; 
    assign t_wb_control = t_wb_control_copy;
    assign t_wb_regdata = t_wb_regdata_copy;
    assign t_wb_pc = t_wb_pc_copy;
    assign PCSrc_flag = PCSrc_flag_copy;
DataMem DataMem0(
    .rst_n(rst_n),
	.input_write_flag(input_control[3]),
	.input_read_flag(input_control[4]),
	.input_addr(input_addr),
	.input_data(input_data),
	.dr_data(t_wb_memdata)
);
endmodule
