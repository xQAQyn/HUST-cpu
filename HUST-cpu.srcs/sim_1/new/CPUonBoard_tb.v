`timescale 1ns / 1ps

module CPUonBoard_tb();
    reg clk;
    always begin
        #10 clk <= 0;
        #10 clk <= 1;
    end
    
    wire [7:0] AN;
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [15:0] LED;
    wire CPUclk;
    
    PipelineCPUonBoard #1 CPU(
        .CLK100MHZ(clk),
        .BTNC(1'b0),
        .BTNU(1'b0),
        .BTNL(1'b0),
        .BTNR(1'b0),
        .BTND(1'b0),
        .AN(AN),
        .CA(CA), 
        .CB(CB), 
        .CC(CC), 
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP),
        .LED(LED)
    );
endmodule
