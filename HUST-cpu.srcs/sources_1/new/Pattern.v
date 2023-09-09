module Pattern(code, patt);
    input [3:0] code;
    output reg [7:0] patt;
    
    always @(code[3:0]) begin
        case(code[3:0])
            4'h0    :   patt[7:0] = 8'b11000000;
            4'h1    :   patt[7:0] = 8'b11111001;
            4'h2    :   patt[7:0] = 8'b10100100;
            4'h3    :   patt[7:0] = 8'b10110000;
            4'h4    :   patt[7:0] = 8'b10011001;
            4'h5    :   patt[7:0] = 8'b10010010;
            4'h6    :   patt[7:0] = 8'b10000010;
            4'h7    :   patt[7:0] = 8'b11111000;
            4'h8    :   patt[7:0] = 8'b10000000;
            4'h9    :   patt[7:0] = 8'b10011000;
            4'ha    :   patt[7:0] = 8'b10001000;
            4'hb    :   patt[7:0] = 8'b10000011;
            4'hc    :   patt[7:0] = 8'b11000110;
            4'hd    :   patt[7:0] = 8'b10100001;
            4'he    :   patt[7:0] = 8'b10000110;
            default :   patt[7:0] = 8'b10001110;
        endcase
    end
endmodule