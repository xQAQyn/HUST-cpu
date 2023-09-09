`timescale 1ns / 1ps

module MEM_WB_Interface(
    input [31:0] MEM_PC,
    input [31:0] MEM_IR,
    input [31:0] MEM_Data,
    input MEM_Jtype,
    input [31:0] MEM_ALUResult,
    input MEM_MemToReg,
    input MEM_RegWrite,
    input [4:0] MEM_WR,
    
    output reg[31:0] WB_PC,
    output reg[31:0] WB_IR,
    output reg[31:0] WB_Data,
    output reg WB_Jtype,
    output reg[31:0] WB_ALUResult,
    output reg WB_MemToReg,
    output reg WB_RegWrite,
    output reg[4:0] WB_WR,
    
    input clk,
    input rst
);

    initial begin
        WB_PC <= 32'b0;
        WB_IR <= 32'b0;
        WB_Data <= 32'b0;
        WB_Jtype <= 1'b0;
        WB_ALUResult <= 32'b0;
        WB_MemToReg <= 1'b0;
        WB_RegWrite <= 1'b0;
        WB_WR <= 5'b0;
    end

    always @(posedge clk) begin
        if(rst) begin
            WB_PC <= 32'b0;
            WB_IR <= 32'b0;
            WB_Data <= 32'b0;
            WB_Jtype <= 1'b0;
            WB_ALUResult <= 32'b0;
            WB_MemToReg <= 1'b0;
            WB_RegWrite <= 1'b0;
            WB_WR <= 5'b0;
        end
        else begin
            WB_PC <= MEM_PC;
            WB_IR <= MEM_IR;
            WB_Data <= MEM_Data;
            WB_Jtype <= MEM_Jtype;
            WB_ALUResult <= MEM_ALUResult;
            WB_MemToReg <= MEM_MemToReg;
            WB_RegWrite <= MEM_RegWrite;
            WB_WR <= MEM_WR;
        end
    end
endmodule
