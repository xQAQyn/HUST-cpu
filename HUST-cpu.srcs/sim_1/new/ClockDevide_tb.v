`timescale 1ns / 1ps

module ClockDevide_tb();
    reg clk;
    wire clk_N;
    
    always begin
        #10 clk <= 0;
        #10 clk <= 1;
    end
    
    ClockDevide #5 devider(clk,clk_N);
endmodule
