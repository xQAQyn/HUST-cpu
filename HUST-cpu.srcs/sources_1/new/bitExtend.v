`timescale 1ns / 1ps

module bitExtend(
    input [inWidth-1:0] inNum,
    output [outWidth-1:0] outNum
);
    parameter inWidth = 16, outWidth = 32;
    assign outNum = { {(outWidth-inWidth){inNum[inWidth-1]}} , inNum };
endmodule
