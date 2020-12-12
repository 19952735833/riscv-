`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 16:41:34
// Design Name: 
// Module Name: ID
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
// input write_data  // 写回
// 实现control功能 ，其他功能使用子模块


module ID(
	input clk,
	input res_n,
	input[31:0] instruction,
	input[31:0] if_id_pc,
	output reg[31:0] id_em_pc,
	output reg[7:0] id_ex_control,
	output reg[31:0] id_ex0,
	output reg[31:0] id_ex1,
	output reg[31:0] id_ex_imm,
	output reg[3:0] id_ex_ALU_control
	);
reg[7:0] temp;
always @ (posedge clk or negedge res_n)begin
	temp[7:0] <= instruction[7:2];			//这样赋值是否可行？  即 temp = 000 01100
	if(~res_n)begin
		id_ex_control <= 8'h00;
		id_ex0 <= 32'h00000000;
		id_ex1 <= 32'h00000000;
		id_ex_imm <= 32'h0000_0000;
		id_ex_ALU_control <= 4'h0;
		id_ex_pc <= 32'h0000_0000;
	end
	else begin
		id_ex_pc <= if_id_pc;
		case(temp)
			8'b00001100 :begin			//只写了 R型指令
				id_ex_control[7:0] <= 8'b00100010;
				id_ex_ALU_control[3:0] <= {instruction[30], instruction[14:12]};
			end


		endcase
	end
end


/* 寄存器堆 */
Regfile Regfile0(
	clk(clk),
	res_n(res_n),
	reg_write(id_ex_control[5]),
	//write_reg_data
	write_reg_addr(instruction[11:7]),
	reg_control(id_ex_control[4]),
	read_reg0_addr(instruction[19:15]),
	read_reg1_addr(instruction[24:20]),
	read_reg0_data0(id_ex0),
	read_reg1_data1(id_ex1)
);

/* 立即数生成单元 */
ImmGen ImmGen0(
	clk(clk),
	res_n(res_n),
	instruction(instruction),
	control(temp),
	imm(id_ex_imm)
);

endmodule
