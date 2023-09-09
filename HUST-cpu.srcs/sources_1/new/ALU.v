`timescale 1ns / 1ps

module ALU(
    input wire[31:0] x,
    input wire[31:0] y,
    input wire[3:0] ALUop,
    output reg[31:0] result1,
    output reg[31:0] result2,
    output wire equal,
    output wire ge,
    output reg less
);
    
    reg[63:0] temp;
    
    assign equal = (x == y) ? 32'b1 : 32'b0;
    assign ge = !less;
    always @(*) begin
        case(ALUop)
            4'b0000: begin
                result1 <= x << y[4:0];
                result2 <= 0;
                less <= 1'b0;
            end
            4'b0001: begin
                result1 <= $signed(x) >>> y[4:0];
                result2 <= 0;
                less <= 1'b0;
            end
            4'b0010: begin
                result1 <= x >> y[4:0];
                result2 <= 0;
                less <= 1'b0;
            end
            4'b0011: begin
                temp <= x * y;
                result1 <= temp[31:0];
                result2 <= temp[63:32];
                less <= 1'b0;
            end
            4'b0100: begin
                result1 <= x / y;
                result2 <= x % y;
                less <= 1'b0;
            end
            4'b0101: begin
                result1 <= x + y;
                result2 <= 0;
                less <= 1'b0;
            end
            4'b0110: begin
                result1 <= x - y;
                result2 <= 0;
                less <= 1'b0;
            end
            4'b0111: begin
                result1 <= x & y;
                result2 <= 0;
                less <= 1'b0;
            end
            4'b1000: begin
                result1 <= x | y;
                result2 <= 0;
                less <= 1'b0;
            end
            4'b1001: begin
                result1 <= x ^ y;
                result2 <= 0;
                less <= 1'b0;
            end
            4'b1010: begin
                result1 <= ~(x | y);
                result2 <= 0;
                less <= 1'b0;
            end
            4'b1011: begin
                result1 <= ($signed(x) < $signed(y)) ? 32'b1 : 32'b0;
                result2 <= 0;
                less <= ($signed(x) < $signed(y)) ? 1'b1 : 1'b0;
            end
            4'b1100: begin
                result1 <= (x < y) ? 32'b1 : 32'b0;
                result2 <= 0;
                less <= (x < y) ? 1'b1 : 1'b0;
            end
            default: begin
                result1 <= 0;
                result2 <= 0;
                less <= 0;
            end
        endcase
    end
endmodule
