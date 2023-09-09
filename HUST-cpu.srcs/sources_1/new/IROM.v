`timescale 1ns / 1ps

module IROM(
    input wire[9:0] addr,
    output wire[31:0] IR
);
    parameter cntIns = 300;
    reg[31:0] instruction[cntIns-1:0];
    
    assign IR = addr < cntIns ? instruction[addr] : 0;
    
    initial begin
        $readmemh("risc-v-benchmark-ccab.mem", instruction, 0);
    end
endmodule
