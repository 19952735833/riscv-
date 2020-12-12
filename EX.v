`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 18:26:47
// Design Name: 
// Module Name: EX
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
// 实现ALU ，其他功能使用子模块
// 需要标志寄存器   如溢出，0标志位    //标志寄存器作用域就在 EX 阶段

module EX(
	input clk,
	input res_n,
	input[31:0] input_reg0,
	input[31:0] input_reg1,
	input[31:0] input_imm,
	input[7:0] input_control,
	input[3:0] input_ALU_control,
	input[31:0] input_pc,
	output reg[7:0] ex_mem_control,
	output reg[31:0] ex_mem_pc,
	output reg[31:0] ex_mem_ALU_result,
	output reg[31:0] ex_mem_write_data,
	output reg zero_flag
    );

    reg[31:0] read_MUX;	// read from MUX
    reg[3:0] ALU_control;	//这个是翻译过来的ALU_control
    reg zero_reg;  //零标志寄存器

MUX MUX1(		//指令少，必要性不大
	clk(clk),
	res_n(res_n),
	input_data0(input_reg1),
	input_data1(input_imm),	
	input_control(input_control[7]),
	output_data(read_MUX),
);

ALU_Control(
	clk(clk),
	res_n(res_n),
	input_data(input_ALU_control),
	input_control(input_control[1:0]),
	output_data(ALU_control)
);

always @ (posedge clk or negedge res_n)begin
	if(~res_n)begin
		ex_mem_ALU_result[31:0] <= 32'h0000_0000;
		ex_mem_write_data[31:0] <= 32'h0000_0000;
		ex_mem_pc[31:0] <= 32'h0000_0000;
		zero_flag <= 1'b0;
		ex_mem_control[7:0] <= 8'h00;
	end
	else begin
		ex_mem_pc <= input_pc + (input_imm);		// 立即数移位有疑问？？？？？
		ex_mem_control[7:0] <= input_control;
		ex_mem_write_data <= input_reg1;
		case(ALU_control)
			4'b0010: begin
				ex_mem_ALU_result <= input_reg0 + read_MUX; // add
			end
			4'b0110: begin
				ex_mem_ALU_result <= input_reg0 - read_MUX; // sub
			end
			4'b0000: begin
				ex_mem_ALU_result <= input_reg0 & read_MUX; // and
			end
			4'b0001: begin
				ex_mem_ALU_result <= input_reg0 | read_MUX; //or
			end
		endcase
		if(~ex_mem_ALU_result)begin
			zero_reg <= 1'b1;
		end 
		else begin
			zero_reg <= 1'b0;
		end
		zero_flag <= zero_reg;
	end
end
endmodule
