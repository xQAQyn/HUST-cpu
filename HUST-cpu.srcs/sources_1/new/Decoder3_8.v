`timescale 1ns / 1ps

module Decoder3_8(num, sel);
    input [2:0] num;
    output reg [7:0] sel;
    
    always @(num[2:0]) begin
        case (num[2:0])
            4'h0    :   sel[7:0] = 8'b11111110;
            4'h1    :   sel[7:0] = 8'b11111101;
            4'h2    :   sel[7:0] = 8'b11111011;
            4'h3    :   sel[7:0] = 8'b11110111;
            4'h4    :   sel[7:0] = 8'b11101111;
            4'h5    :   sel[7:0] = 8'b11011111;
            4'h6    :   sel[7:0] = 8'b10111111;
            4'h7    :   sel[7:0] = 8'b01111111;
            default :   sel[7:0] = 8'b11111111;
        endcase
    end
endmodule
