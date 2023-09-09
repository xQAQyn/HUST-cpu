`timescale 1ns / 1ps

module IntController(
    input IR1,
    input IR2,
    input IR3,
    input CLR,
    input clk,
    input rst,
    output W1,
    output W2,
    output W3,
    output reg[1:0] IntNo,
    output reg IntR
);
    reg sample1, sample2, sample3;
    reg wait1, wait2, wait3;
    wire waitIn1, waitIn2, waitIn3;
    reg CLR1, CLR2, CLR3;
    
    assign waitIn1 = (sample1 || wait1) && !CLR1;
    assign waitIn2 = (sample2 || wait2) && !CLR2;
    assign waitIn3 = (sample3 || wait3) && !CLR3;

    assign W1 = sample1 || wait1;
    assign W2 = sample2 || wait2;
    assign W3 = sample3 || wait3;
    
    initial begin
        wait1 <= 0;
        wait2 <= 0;
        wait3 <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wait1 <= 0;
            wait2 <= 0;
            wait3 <= 0;
        end
        else begin
            wait1 <= waitIn1;
            wait2 <= waitIn2;
            wait3 <= waitIn3;
        end
        
    end

    always @(*) begin
        if(rst || wait1)
            sample1 <= 0;
        else if(IR1)
            sample1 <= 1;
    end

    always @(*) begin
        if(rst || wait2)
            sample2 <= 0;
        else if(IR2)
            sample2 <= 1;
    end

    always @(*) begin
        if(rst || wait3)
            sample3 <= 0;
        else if(IR3)
            sample3 <= 1;
    end
    
    always @(*) begin
        if(wait3) begin
            IntNo <= 3;
            IntR <= 1;
        end
        else if(wait2) begin
            IntNo <= 2;
            IntR <= 1;
        end
        else if(wait1) begin
            IntNo <= 1;
            IntR <= 1;
        end
        else IntR <= 0;
    end

    always @(*) begin
        if(CLR && IntNo == 1)
            CLR1 <= 1;
        else CLR1 <= 0;
        if(CLR && IntNo == 2)
            CLR2 <= 1;
        else CLR2 <= 0;
        if(CLR && IntNo == 3)
            CLR3 <= 1;
        else CLR3 <= 0;
    end

endmodule
