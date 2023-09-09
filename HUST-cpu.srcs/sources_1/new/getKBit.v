`timescale 1ns / 1ps

module getKBit(
    input [31:0] number,
    input [2:0] k,
    output reg [3:0] result
);
    always @(*) begin
        case(k)
            3'b000: result <= number[3:0];
            3'b001: result <= number[7:4];
            3'b010: result <= number[11:8];
            3'b011: result <= number[15:12];
            3'b100: result <= number[19:16];
            3'b101: result <= number[23:20];
            3'b110: result <= number[27:24];
            3'b111: result <= number[31:28];
        endcase
    end
endmodule
