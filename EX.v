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
// �?要标志寄存器   如溢出，0标志�?    //标志寄存器作用域就在 EX 阶段

module EX(
	input rst_n,
	input[31:0] input_reg0,
	input[31:0] input_reg1,
	input[31:0] input_imm,
	input[7:0] input_control,
	input[4:0] input_ALU_control,
	input[31:0] input_pc,
	input input_pro_control,
	input[4:0] input_reg0_addr,
	input[4:0] input_reg1_addr,
	input[4:0] input_reg_addr,
	input[4:0] input_expro_addr,
	input[4:0] input_mempro_addr,
	input[31:0] input_expro_data,
	input[31:0] input_mempro_data,
	output sign_flag,
	output[4:0] t_mem_reg_addr,
	output[7:0] t_mem_control,
	output[31:0] t_mem_pc,
	output[31:0] t_mem_ALU_result,
	output[31:0] t_mem_write_data,
	output zero_flag,
	output reg pc_stop,
	output[1:0] output_ls
    );
    reg sign_flag_copy;
    wire[31:0] read_MUX;	// read from MUX
    wire[4:0] ALU_control;	//这个是翻译过来的ALU_control
    reg zero_reg;  //零标志寄存器
    reg[4:0] t_mem_reg_addr_copy;
    reg[7:0] t_mem_control_copy;
    reg[31:0] t_mem_pc_copy;
    reg[31:0] t_mem_ALU_result_copy;
    reg[31:0] t_mem_write_data_copy;
        
    wire[31:0] read_MUX0;
    wire[31:0] read_MUX1;
    wire output_stop0;
    wire output_stop1;
    
MUX_EX MUX_EX0(
    .rst_n(rst_n),
    .input_addr(input_reg0_addr),
    .input_expro_addr(input_expro_addr),
    .input_mempro_addr(input_mempro_addr),
    .input_data(input_reg0),
    .input_expro_data(input_expro_data),  
    .input_mempro_data(input_mempro_data),  
    .input_control(input_pro_control),
    .output_data(read_MUX0),
    .output_stop(output_stop0)
);
MUX_EX MUX_EX1(
    .rst_n(rst_n),
    .input_addr(input_reg1_addr),
    .input_expro_addr(input_expro_addr),
    .input_mempro_addr(input_mempro_addr),
    .input_data(input_reg1),
    .input_expro_data(input_expro_data),  
    .input_mempro_data(input_mempro_data),  
    .input_control(input_pro_control),
    .output_data(read_MUX1),
    .output_stop(output_stop1)
    );
MUX MUX1(		//指令少，必要性不�?
	.rst_n(rst_n),
	.input_data0(read_MUX1),
	.input_data1(input_imm),	
	.input_control(input_control[7]),
	.output_data(read_MUX)
);

ALU_Control ALU_Control0(
	.rst_n(rst_n),
	.input_data(input_ALU_control),
	.input_control(input_control[1:0]),
	.output_data(ALU_control),
	.output_l(output_ls)
);

always @ (*)begin
	if(~rst_n)begin
		t_mem_ALU_result_copy[31:0] <= 32'h0000_0000;
		t_mem_write_data_copy[31:0] <= 32'h0000_0000;
		t_mem_pc_copy[31:0] <= 32'h0000_0000;
		zero_reg <= 1'b0;
		t_mem_control_copy[7:0] <= 8'h00;
		t_mem_reg_addr_copy[4:0] <= 5'b00000;
		pc_stop <= 1'b0;
		sign_flag_copy <= 1'b0;
	end
	else begin
	    if((output_stop0 || output_stop1))begin
	            t_mem_ALU_result_copy[31:0] <= 32'h0000_0000;
                t_mem_write_data_copy[31:0] <= 32'h0000_0000;
                t_mem_pc_copy[31:0] <= 32'h0000_0000;
                zero_reg <= 1'b0;
                t_mem_control_copy[7:0] <= 8'h00;
                t_mem_reg_addr_copy[4:0] <= 5'b00000;
                pc_stop <= 1'b1;
                sign_flag_copy <= 1'b0;
	    end
	    else begin
		t_mem_pc_copy[31:0] <= input_pc[31:0] + input_imm[31:0];		// 立即数移位有疑问？？？？�?
		t_mem_control_copy[7:0] <= input_control[7:0];
		t_mem_write_data_copy[31:0] <= input_reg1[31:0];
		t_mem_reg_addr_copy[4:0] <= input_reg_addr[4:0];
		pc_stop <= 1'b0;
		case(ALU_control)
			5'b00010: begin
				t_mem_ALU_result_copy <= read_MUX0 + read_MUX; // add
			end
			5'b00110: begin
				t_mem_ALU_result_copy <= read_MUX0 - read_MUX; // sub
			end
			5'b00000: begin
				t_mem_ALU_result_copy <= read_MUX0 & read_MUX; // and
			end
			5'b00001: begin
				t_mem_ALU_result_copy <= read_MUX0 | read_MUX; //or
		    end
		    
		    5'b00001: begin
		        t_mem_ALU_result_copy <= read_MUX0 << read_MUX; // sll
			end
			5'b00101: begin
                t_mem_ALU_result_copy <= read_MUX0 >> read_MUX; // srl
            end
            
            5'b00100: begin
                t_mem_ALU_result_copy <= read_MUX0 ^ read_MUX; // xor
            end
            5'b00111: begin
                t_mem_ALU_result_copy <= read_MUX0 * read_MUX; // mul
            end
            5'b01000: begin
                t_mem_ALU_result_copy <= read_MUX0 / read_MUX; // mul
            end
            5'b10101:begin
                t_mem_ALU_result_copy <= read_MUX0 >> read_MUX;    //��Ҫ����
            end
		endcase
		if(t_mem_ALU_result_copy)begin
            zero_reg <= 1'b0;
            sign_flag_copy <= 1'b0;
        end 
        else begin
        if(t_mem_ALU_result_copy == 1'b0)begin zero_reg <= 1'b1;sign_flag_copy <= 1'b0; end
        else  begin
           zero_reg <= 1'b0; sign_flag_copy <= 1'b1; // 1Ϊ ����
        end
        end
        end
	end
end
    assign zero_flag = zero_reg;
    assign t_mem_reg_addr = t_mem_reg_addr_copy;
    assign t_mem_control = t_mem_control_copy;
    assign t_mem_pc = t_mem_pc_copy;
    assign t_mem_ALU_result = t_mem_ALU_result_copy;
    assign t_mem_write_data = t_mem_write_data_copy;
    assign sign_flag = sign_flag_copy;
    
endmodule
