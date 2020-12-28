`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 22:51:39
// Design Name: 
// Module Name: MUX_EX
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


module MUX_EX(
    input rst_n,
    input[4:0] input_addr,
    input[4:0] input_expro_addr,
    input[4:0] input_mempro_addr,
    input[31:0] input_data,
    input[31:0] input_expro_data,  
    input[31:0] input_mempro_data,  
    input input_control,
    output reg[31:0] output_data,
    output reg output_stop
    );
always @(*)begin  // R type
    if(input_control == 1)begin
    if(~rst_n)begin
        output_data <= {32{1'b0}};
        output_stop <= 1'b0;   // ²»²ÎÓërst_n
    end
    else begin
        output_stop <= 1'b0;
        if(input_addr[4:0] == 5'b00000)begin
            output_data <= {32{1'b0}};
        end
        else begin
            if(input_addr[4:0] == input_expro_addr[4:0])begin
               output_data <= input_expro_data;
           end
           else if(input_addr[4:0] == input_mempro_addr[4:0])begin
               output_data <= input_mempro_data;
           end
           else begin
               output_data <= input_data;
           end
        end
    end
    end

    if(input_control == 0)begin
  if(~rst_n)begin
      output_data <= {32{1'b0}};
      output_stop <= 1'b0;
  end
  else begin
    if(input_addr[4:0] == 5'b00000)begin
         output_data <= {32{1'b0}};
         output_stop <= 1'b0;
    end
    else begin
        if(input_addr[4:0] == input_expro_addr[4:0])begin
                output_stop <= 1'b1;
                output_data <= {32{1'b0}};//{32{1'b0}};
            end
            else if(input_addr[4:0] == input_mempro_addr[4:0])begin
                output_data <= input_mempro_data;
                output_stop <= 1'b0;
            end
            else begin
                output_data <= input_data;
                output_stop <= 1'b0;
            end   
    end
  end
  end
end
endmodule
