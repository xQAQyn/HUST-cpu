`timescale 1ns / 1ps

module IF_ID_Interface(
    input [31:0] IF_PC,
    input [31:0] IF_IR,
    output reg[31:0] ID_PC,
    output reg[31:0] ID_IR,
    input stall,
    input clk,
    output pause,
    input rst
);
    assign pause = !stall;
    
    initial begin
        ID_PC <= 0;
        ID_IR <= 0;
    end
    
    always @(posedge clk) begin
        if(!stall) begin
            ID_PC <= ID_PC;
            ID_IR <= ID_IR;
        end
        else if(rst) begin
            ID_PC <= 0;
            ID_IR <= 0;
        end
        else begin
            ID_PC <= IF_PC;
            ID_IR <= IF_IR;
        end
    end
endmodule
