module ClockDevide(
    input CLK100MHZ,
    output reg clk_N
);
    
    parameter delay = 50000000;
    reg [31:0] cnt;
    
    initial begin
        clk_N <= 0;
        cnt <= 0;
    end
    
    always @(posedge CLK100MHZ) begin
        cnt = cnt + 1;
        if(cnt == delay) begin
            cnt = 32'b0;
            clk_N = ~clk_N;
        end
    end
endmodule