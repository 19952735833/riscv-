`timescale 1ns / 1ps

module WB(
    input rst_n,  
    input[31:0] input_regdata,
    input[31:0] input_memdata,
    input[7:0] input_control,
    input[4:0] input_reg_addr,
    output[4:0] wb_single,
    output[31:0] wb_data,
    output reg wb_control
);
reg[4:0] wb_single_copy;
always @(*)begin     //ºÍifÒ»Ñù
    if(input_control[5] == 1'b0) begin
	wb_single_copy[4:0] <= 5'b00000;
		//wb_data[31:0] <= 32'h0000_0000;
	wb_control <= 1'b0;
	end
    else begin
    if(~rst_n)begin
		wb_single_copy[4:0] <= 5'b00000;
		wb_control <= 1'b0;
		//wb_data[31:0] <= 32'h0000_0000;
	end
		wb_single_copy[4:0] <= input_reg_addr;
		wb_control <= 1'b1;
	end
end
assign wb_single = wb_single_copy;
MUX MUX2(
    .rst_n(rst_n),
    .input_data0(input_regdata),
    .input_data1(input_memdata),
    .input_control(input_control[3]),
    .output_data(wb_data)
);
endmodule