`timescale 1ns / 1ps

module SCCPUonBoard(
    input CLK100MHZ,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND,
    output[7:0] AN,
    output CA, 
    output CB, 
    output CC, 
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output [15:0] LED
//    output wire [31:0] LEDInfo
);
    wire [31:0] LEDInfo;
    parameter clk_control = 5000000;
    wire clk_Display, clk_CPU, clk_Test;
    ClockDevide #(clk_control) getClk( //#1000000 100Hz
        .CLK100MHZ(CLK100MHZ),
        .clk_N(clk_CPU)
    );
    ClockDevide #100000 getDisplayClk(
        .CLK100MHZ(CLK100MHZ),
        .clk_N(clk_Display)
    );
    
    SingleCycleCPU CPU(
        .IR1(BTNR),
        .IR2(BTNC),
        .IR3(BTNL),
//        .IR1(1'b0),
//        .IR2(1'b0),
//        .IR3(1'b0),
        .Go(BTNU),
        .clk(clk_CPU),
        .rst(BTND),
        .LEDInfo(LEDInfo),
        .halt(LED[0]),
        .W1(LED[1]),
        .W2(LED[2]),
        .W3(LED[3])
    );
    
    LEDDisplay_32bit Display(
        .number(LEDInfo),
        .clk(clk_Display),
        .AN(AN),
        .Seg7({DP,CG,CF,CE,CD,CC,CB,CA})
    );
    
    always @(posedge clk_CPU) begin
        $display("LEDInfo:%h", LEDInfo);
    end
    
endmodule
