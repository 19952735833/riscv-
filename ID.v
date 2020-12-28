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
// input write_data  // 鍐欏洖
// 瀹炵幇control鍔熻兘 锛屽叾浠栧姛鑳戒娇鐢ㄥ瓙妯″潡


module ID(
	input rst_n,
	input[31:0] instruction,
	input[31:0] input_pc,
	input[4:0] input_wb_single,
	input[31:0] input_wb_data,
	input input_wb_control,
	output[31:0] t_ex_pc,
	output[7:0] t_ex_control,
	output[31:0] id0,
	output[31:0] id1,
	output[4:0] id0_addr,
	output[4:0] id1_addr,
	output[31:0] id_imm,
	output[4:0] t_ex_ALU_control,
	output[4:0] t_ex_reg_addr,
	output reg pc_nop_control
	);
reg[6:0] temp;
reg[31:0] t_ex_pc_copy;
reg[7:0] t_ex_control_copy;
reg[4:0] t_ex_ALU_control_copy;
reg[31:0] t_ex_reg_addr_copy;
wire[4:0] read_id0 = instruction[19:15];
wire[4:0] read_id1 = instruction[24:20];
assign id0_addr = read_id0;
assign id1_addr = read_id1;
reg reg_en;
always @ (*)begin
	temp[6:0] <= instruction[6:0];			//杩欐牱璧嬪?兼槸鍚﹀彲琛岋紵  鍗? temp = 000 01100
	if(~rst_n)begin
		t_ex_control_copy <= 8'h00;
		t_ex_ALU_control_copy <= 5'b00000;
		t_ex_pc_copy <= 32'h0000_0000;
		t_ex_reg_addr_copy <= 5'b00000;
		temp <= 7'b000_0000;
		reg_en <= 1'b0;
		pc_nop_control <= 1'b0;
	end
	else begin
	    pc_nop_control <= 1'b0;
		t_ex_pc_copy <= input_pc;
		t_ex_reg_addr_copy[4:0] <= 5'b00000;
		case(temp)
		    7'b0000000 :begin   //空指令  各个控制信号都是空
		        t_ex_control_copy[7:0] <= 8'b0000_0000;
		        reg_en <= 1'b0;
		    end
			7'b0110011 :begin			//鍙啓浜? R鍨嬫寚浠?
			    t_ex_reg_addr_copy[4:0] <= instruction[11:7];
				t_ex_control_copy[7:0] <= 8'b00100010;
				t_ex_ALU_control_copy[4:0] <= {instruction[30],instruction[24], instruction[14:12]};
				reg_en <= 1'b1;
			end
			7'b0100011 :begin
			    t_ex_control_copy[7:0] <= 8'b10001000;   //sd
			    t_ex_ALU_control_copy[4:0] <= {0,0, instruction[14:12]};
			    reg_en <= 1'b1;
			end
            7'b0000011 :begin
                t_ex_reg_addr_copy[4:0] <= instruction[11:7];
                t_ex_control_copy[7:0] <= 8'b11110000;
                t_ex_ALU_control_copy[4:0] <= {0 , 0, instruction[14:12]};
                reg_en <= 1'b1;
            end
            7'b1000011 :begin   // 我该动的i型指令
                t_ex_reg_addr_copy[4:0] <= instruction[11:7];
                t_ex_control_copy[7:0] <= 8'b10100010;
                t_ex_ALU_control_copy[4:0] <= {0,0, instruction[14:12]};
                reg_en <= 1'b1;
            end
            7'b1100011 :begin //beq
                t_ex_control_copy[7:0] <= 8'b00000101;
                t_ex_ALU_control_copy[4:0] <= {0,0, instruction[14:12]};
                reg_en <= 1'b1;
                pc_nop_control <= 1'b1;
            end
		endcase
	end
end
assign t_ex_pc = t_ex_pc_copy;
assign t_ex_control = t_ex_control_copy;
assign t_ex_ALU_control = t_ex_ALU_control_copy;
assign t_ex_reg_addr = t_ex_reg_addr_copy;

/* 瀵勫瓨鍣ㄥ爢 */
Regfile Regfile0(
	.rst_n(rst_n),
	.reg_en(reg_en),
	.reg_write(input_wb_control),
	.write_reg_data(input_wb_data),
	.write_reg_addr(input_wb_single),
	.reg_control(t_ex_control[4]),
	.read_reg0_addr(read_id0),
	.read_reg1_addr(read_id1),
	.read_reg0_data(id0),
	.read_reg1_data(id1)
);

/* 绔嬪嵆鏁扮敓鎴愬崟鍏? */
ImmGen ImmGen0(
	.rst_n(rst_n),
	.instruction(instruction),
	.control(temp),
	.imm(id_imm)
);

endmodule
