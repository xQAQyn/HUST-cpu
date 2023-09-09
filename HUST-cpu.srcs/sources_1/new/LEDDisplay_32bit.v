`timescale 1ns / 1ps

module LEDDisplay_32bit(
    input [31:0] number,
    input clk,
    output wire [7:0] AN,
    output wire [7:0] Seg7
);
    reg [2:0] cnt;
    always @(posedge clk) begin
        cnt <= cnt + 1;
    end
    
    wire [3:0] hex;
    Decoder3_8 getAN(cnt, AN);
    getKBit getHex(number, cnt, hex);
    Pattern patt(hex[3:0], Seg7);
    
endmodule
