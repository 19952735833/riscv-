`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 13:46:47
// Design Name: 
// Module Name: Regfile
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


module Regfile(
	input rst_n,
	input reg_en,
	input reg_write,
	input[31:0] write_reg_data,
	input[4:0] write_reg_addr,
	input reg_control,
	input[4:0] read_reg0_addr,
	input[4:0] read_reg1_addr,
	output[31:0] read_reg0_data,
	output[31:0] read_reg1_data
    );

reg[31:0] reg_mem[0:31];
reg[31:0] read_reg0_data_copy;
reg[31:0] read_reg1_data_copy;
initial $readmemh ("reg.data", reg_mem);
always @ (*)begin
	if(~rst_n)begin
		read_reg0_data_copy[31:0] <= 32'h0000_0000;
		read_reg1_data_copy[31:0] <= 32'h0000_0000;
	end
	else begin 
	if(reg_en||reg_write)begin
		if(reg_control)begin  // 如果�?1 不读第二个寄存器
			 read_reg0_data_copy <= reg_mem[read_reg0_addr[4:0]];
		end
		else if(~reg_control)begin
                 read_reg0_data_copy <= reg_mem[read_reg0_addr[4:0]];
                 read_reg1_data_copy <= reg_mem[read_reg1_addr[4:0]];
		end
		//else  �?要报�?
		if(reg_write)begin
			reg_mem[write_reg_addr[4:0]] <= write_reg_data;
		end
    end
	end
end
assign read_reg0_data = read_reg0_data_copy;
assign read_reg1_data = read_reg1_data_copy;

endmodule
