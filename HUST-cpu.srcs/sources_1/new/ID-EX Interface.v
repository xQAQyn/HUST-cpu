`timescale 1ns / 1ps

module ID_EX_Interface(
    input [31:0] ID_PC,
    input [31:0] ID_IR,
    input [3:0] ID_ALUop,
    input [4:0] ID_WR,
    input ID_MemToReg,
    input ID_MemWrite,
    input ID_ALU_SRC,
    input ID_RegWrite,
    input ID_uret,
    input ID_ecall,
    input ID_Beq,
    input ID_Bne,
    input ID_Jalr,
    input ID_Jal,
    input ID_Lui,
    input ID_Lhu,
    input ID_Bltu,
    input ID_CSRRSI,
    input ID_CSRRCI,
    input ID_Load,
    input [1:0] ID_R1Control,
    input [1:0] ID_R2Control,
    input [31:0] ID_R1,
    input [31:0] ID_R2,
    input [31:0] ID_Imm,
    
    
    output reg[31:0] EX_PC,
    output reg[31:0] EX_IR,
    output reg[3:0] EX_ALUop,
    output reg[4:0] EX_WR,
    output reg EX_MemToReg,
    output reg EX_MemWrite,
    output reg EX_ALU_SRC,
    output reg EX_RegWrite,
    output reg EX_uret,
    output reg EX_ecall,
    output reg EX_Beq,
    output reg EX_Bne,
    output reg EX_Jalr,
    output reg EX_Jal,
    output reg EX_Lui,
    output reg EX_Lhu,
    output reg EX_Bltu,
    output reg EX_CSRRSI,
    output reg EX_CSRRCI,
    output reg EX_Load,
    output reg[1:0] EX_R1Control,
    output reg[1:0] EX_R2Control,
    output reg[31:0] EX_R1,
    output reg[31:0] EX_R2,
    output reg[31:0] EX_Imm,
    
    input clk,
    input rst
);
    initial begin
        EX_PC <= 32'b0;
        EX_IR <= 32'b0;
        EX_ALUop <= 4'b0;
        EX_WR <= 5'b0;
        EX_MemToReg <= 1'b0;
        EX_MemWrite <= 1'b0;
        EX_ALU_SRC <= 1'b0;
        EX_RegWrite <= 1'b0;
        EX_uret <= 1'b0;
        EX_ecall <= 1'b0;
        EX_Beq <= 1'b0;
        EX_Bne <= 1'b0;
        EX_Jalr <= 1'b0;
        EX_Jal <= 1'b0;
        EX_Lui <= 1'b0;
        EX_Lhu <= 1'b0;
        EX_Bltu <= 1'b0;
        EX_CSRRSI <= 1'b0;
        EX_CSRRCI <= 1'b0;
        EX_Load <= 1'b0;
        EX_R1Control <= 2'b0;
        EX_R2Control <= 2'b0;
        EX_R1 <= 32'b0;
        EX_R2 <= 32'b0;
        EX_Imm <= 32'b0;
    end
    always @(posedge clk) begin
        if(rst) begin
            EX_PC <= 32'b0;
            EX_IR <= 32'b0;
            EX_ALUop <= 4'b0;
            EX_WR <= 5'b0;
            EX_MemToReg <= 1'b0;
            EX_MemWrite <= 1'b0;
            EX_ALU_SRC <= 1'b0;
            EX_RegWrite <= 1'b0;
            EX_uret <= 1'b0;
            EX_ecall <= 1'b0;
            EX_Beq <= 1'b0;
            EX_Bne <= 1'b0;
            EX_Jalr <= 1'b0;
            EX_Jal <= 1'b0;
            EX_Lui <= 1'b0;
            EX_Lhu <= 1'b0;
            EX_Bltu <= 1'b0;
            EX_CSRRSI <= 1'b0;
            EX_CSRRCI <= 1'b0;
            EX_Load <= 1'b0;
            EX_R1Control <= 2'b0;
            EX_R2Control <= 2'b0;
            EX_R1 <= 32'b0;
            EX_R2 <= 32'b0;
            EX_Imm <= 32'b0;
        end
        else begin
            EX_PC <= ID_PC;
            EX_IR <= ID_IR;
            EX_ALUop <= ID_ALUop;
            EX_WR <= ID_WR;
            EX_MemToReg <= ID_MemToReg;
            EX_MemWrite <= ID_MemWrite;
            EX_ALU_SRC <= ID_ALU_SRC;
            EX_RegWrite <= ID_RegWrite;
            EX_uret <= ID_uret;
            EX_ecall <= ID_ecall;
            EX_Beq <= ID_Beq;
            EX_Bne <= ID_Bne;
            EX_Jalr <= ID_Jalr;
            EX_Jal <= ID_Jal;
            EX_Lui <= ID_Lui;
            EX_Lhu <= ID_Lhu;
            EX_Bltu <= ID_Bltu;
            EX_CSRRSI <= ID_CSRRSI;
            EX_CSRRCI <= ID_CSRRCI;
            EX_Load <= ID_Load;
            EX_R1Control <= ID_R1Control;
            EX_R2Control <= ID_R2Control;
            EX_R1 <= ID_R1;
            EX_R2 <= ID_R2;
            EX_Imm <= ID_Imm;
        end
    end
endmodule
