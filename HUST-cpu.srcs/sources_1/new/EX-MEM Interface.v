`timescale 1ns / 1ps

module EX_MEM_Interface(
    input [31:0] EX_PC,
    input [31:0] EX_IR,
    input EX_MemWrite,
    input [31:0] EX_R2,
    input EX_Jtype,
    input [31:0] EX_ALUResult,
    input EX_MemToReg,
    input EX_RegWrite,
    input EX_Lhu,
    input [4:0] EX_WR,
    input EX_Load,
    
    output reg[31:0] MEM_PC,
    output reg[31:0] MEM_IR,
    output reg MEM_MemWrite,
    output reg[31:0] MEM_R2,
    output reg MEM_Jtype,
    output reg[31:0] MEM_ALUResult,
    output reg MEM_MemToReg,
    output reg MEM_RegWrite,
    output reg MEM_Lhu,
    output reg[4:0] MEM_WR,
    output reg MEM_Load,
    
    input clk,
    input rst
);
    initial begin
        MEM_PC <= 32'b0;
        MEM_IR <= 32'b0;
        MEM_MemWrite <= 1'b0;
        MEM_R2 <= 32'b0;
        MEM_Jtype <= 1'b0;
        MEM_ALUResult <= 32'b0;
        MEM_MemToReg <= 1'b0;
        MEM_RegWrite <= 1'b0;
        MEM_WR <= 5'b0;
        MEM_Load <= 1'b0;
        MEM_Lhu <= 1'b0;
    end

    always @(posedge clk) begin
        if(rst) begin
            MEM_PC <= 32'b0;
            MEM_IR <= 32'b0;
            MEM_MemWrite <= 1'b0;
            MEM_R2 <= 32'b0;
            MEM_Jtype <= 1'b0;
            MEM_ALUResult <= 32'b0;
            MEM_MemToReg <= 1'b0;
            MEM_RegWrite <= 1'b0;
            MEM_WR <= 5'b0;
            MEM_Load <= 1'b0;
            MEM_Lhu <= 1'b0;
        end
        else begin
            MEM_PC <= EX_PC;
            MEM_IR <= EX_IR;
            MEM_MemWrite <= EX_MemWrite;
            MEM_R2 <= EX_R2;
            MEM_Jtype <= EX_Jtype;
            MEM_ALUResult <= EX_ALUResult;
            MEM_MemToReg <= EX_MemToReg;
            MEM_RegWrite <= EX_RegWrite;
            MEM_WR <= EX_WR;
            MEM_Load <= EX_Load;
            MEM_Lhu <= EX_Lhu;
        end
    end
endmodule
