`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 19:08:01
// Design Name: 
// Module Name: ALU_Control
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


module ALU_Control(
	input rst_n,
	input[4:0] input_data,
	input[1:0] input_control,		// ALUop
	output[4:0] output_data,
	output[1:0] output_l
    );
reg[4:0] output_data_copy;
reg[1:0] output_ls;
always @ (*)begin
	if(~rst_n)begin
		output_data_copy[4:0] <= 4'h0;
		output_ls <= 2'b00;
	end
	else begin
		case(input_control)
			2'b00: begin
				output_data_copy[4:0] <= 5'b00010;   // p175
				case(input_data)
				    5'b00000:begin
				        output_ls <= 2'b00; //byte
				    end
				    5'b00010:begin
                        output_ls <= 2'b01;  //字
                    end
                    5'b00011: begin
                        output_ls <= 2'b10;  // 双字
                    end
                endcase
			end
			2'b01: begin
				output_data_copy[4:0] <= 5'b00110;
			case(input_data)
				5'b00000:begin
                    output_ls <= 2'b00; //相等跳转
                end
                5'b00001:begin
                    output_ls <= 2'b01;  //不等
                end
                5'b00100: begin
                    output_ls <= 2'b10;  // 小于
                end
                5'b00101: begin
                    output_ls <= 2'b11;
                end
                
            endcase
			end
			3'b10: begin
				case(input_data)
					5'b00000: begin
						output_data_copy[4:0] <= 5'b00010; 	//add
					end
					5'b10000: begin
						output_data_copy[4:0] <= 5'b00110; 	//subtract
					end
					5'b00001: begin
					   output_data_copy[4:0] <= 5'b000011; // sll
					end
					5'b00111: begin
						output_data_copy[4:0] <= 5'b00000; 	//and
					end
					5'b00110: begin
						output_data_copy[4:0] <= 5'b00001; 	//or
					end	
                    5'b00101: begin
                        output_data_copy[4:0] <= 5'b00100;  //srl
                    end
                    5'b00100:begin
                        output_data_copy[4:0] <= 5'b00101; //xor
                    end
                    5'b01000:begin
                        output_data_copy[4:0] <= 5'b00111; //mul
                    end
                   5'b01100:begin
                       output_data_copy[4:0] <= 5'b01000; //div
                   end
                   5'b10101:begin
                       output_data_copy[4:0] <= 5'b01001; //sra
                   end
//                   5'b10101:begin
//                       output_data_copy[4:0] <= 5'b01001; //sra
//                   end
				endcase
			end
		endcase
	end
end
assign output_data = output_data_copy;
assign output_l = output_ls;
endmodule
