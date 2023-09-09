`timescale 1ns / 1ps

module RAM(
    input wire[9:0] Addr,
    input wire[31:0] MRin,
    input WE,
    input CLK,
    input mode,
    output reg[31:0] Data
);
    reg[31:0] mem[4095:0];
    
    always @(*) begin
        if(mode == 1'b0)
            Data <= mem[Addr[9:2]];
        else if(Addr[1] == 1'b0)
            Data <= mem[Addr[9:2]] & 32'hffff;
        else
            Data <= (mem[Addr[9:2]] >> 16) & 32'hffff;
    end
    always @(posedge CLK) begin
        if(WE)
            mem[Addr[9:2]] <= MRin;
    end

endmodule
