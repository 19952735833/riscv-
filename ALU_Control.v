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
	input[3:0] input_data,
	input[1:0] input_control,		// ALUop
	output[3:0] output_data
    );
reg[3:0] output_data_copy;
always @ (*)begin
	if(~rst_n)begin
		output_data_copy[3:0] <= 4'h0;
	end
	else begin
		case(input_control)
			2'b00: begin
				output_data_copy[3:0] <= 4'b0010;   // p175
			end
			2'b01: begin
				output_data_copy[3:0] <= 4'b0110;
			end
			3'b10: begin
				case(input_data)
					4'b0000: begin
						output_data_copy[3:0] <= 4'b0010; 	//add
					end
					4'b1000: begin
						output_data_copy[3:0] <= 4'b0110; 	//subtract
					end
					4'b0111: begin
						output_data_copy[3:0] <= 4'b0000; 	//and
					end
					4'b0110: begin
						output_data_copy[3:0] <= 4'b0001; 	//or
					end
				endcase
			end
		endcase
	end
end
assign output_data = output_data_copy;
endmodule
