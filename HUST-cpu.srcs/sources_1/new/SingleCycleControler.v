`timescale 1ns / 1ps

module SingleCycleControler(
    input wire[31:0] IR,
    output wire[3:0] ALUop,
    output MemToReg,
    output MemWrite,
    output ALU_SRC,
    output RegWrite,
    output uret,
    output ecall,
    output Beq,
    output Bne,
    output Jalr,
    output Jal,
    output Lui,
    output Lhu,
    output Bltu,
    output CSRRSI,
    output CSRRCI
);
    wire OP2, OP3, OP4, OP5, OP6;
    wire F12, F13, F14, F25, F30;
    
    assign {OP6, OP5, OP4, OP3, OP2} = IR[6:2];
    assign {F14, F13, F12} = IR[14:12];
    assign F25 = IR[25];
    assign F30 = IR[30];
    
    assign ALUop[0] = (!OP2 && !OP3 && !OP4 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12 && !F13) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12 && !F14) || (!OP2 && !OP3 && OP4 && !OP6 && !F12 && !F14 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F13 && F14 && !F25 && F30) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F12 && F13 && F14) || (!OP2 && !OP3 && OP4 && !OP6 && F12 && F13 && F14 && !F25 && !F30);
    assign ALUop[1] = (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && OP4 && !OP6 && !F12 && F13 && !F14 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F12 && F14 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F12 && F13 && F14) || (!OP2 && !OP3 && OP4 && !OP6 && F12 && F13 && F14 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && OP5 && !OP6 && !F12 && !F13 && !F14 && !F25 && F30);
    assign ALUop[2] = (!OP2 && !OP3 && !OP4 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14) || (!OP2 && !OP3 && !OP4 && OP5 && OP6 && !F12 && F13 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12 && !F13 && !F14) || (!OP2 && !OP3 && OP4 && !OP6 && !F12 && !F13 && !F14 && !F25) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F12 && F13) || (!OP2 && !OP3 && OP4 && !OP6 && F12 && F13 && !F25 && !F30);
    assign ALUop[3] = (!OP2 && !OP3 && !OP4 && OP5 && OP6 && !F12 && F13 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F13 && !F14) || (!OP2 && !OP3 && OP4 && !OP6 && !F12 && F13 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP6 && F13 && !F14 && !F25 && !F30);

    assign MemToReg = (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14);
    assign MemWrite = (!OP2 && !OP3 && !OP4 && OP5 && !OP6 && !F12 && F13 && !F14);
    assign ALU_SRC = (!OP2 && !OP3 && !OP4 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F14 && !F25) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F13);
    assign RegWrite = (!OP2 && !OP3 && !OP5 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F12) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && !F25 && !F30) || (!OP2 && !OP3 && OP4 && !OP6 && !F12 && !F13 && !F14 && !F25) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F14 && !F25) || (!OP2 && !OP3 && OP4 && !OP5 && !OP6 && F13) || (!OP2 && !OP3 && OP4 && !OP6 && F13 && !F25 && !F30) || (OP2 && !OP4 && OP5 && OP6 && !F12 && !F13 && !F14) || (OP2 && !OP3 && OP4 && OP5 && !OP6) || (OP2 && OP3 && !OP4 && OP5 && OP6);
    assign ecall = !IR[21] && (!OP2 && !OP3 && OP4 && OP5 && OP6 && !F12 && !F13 && !F14 && !F25 && !F30);
    assign uret = IR[21] && (!OP2 && !OP3 && OP4 && OP5 && OP6 && !F12 && !F13 && !F14 && !F25 && !F30);
    assign Beq = !OP2 && !OP3 && !OP4 && OP5 && OP6 && !F12 && !F13 && !F14;
    assign Bne = !OP2 && !OP3 && !OP4 && OP5 && OP6 && F12 && !F13 && !F14;
    assign Jalr = OP2 && !OP3 && !OP4 && OP5 && OP6 && !F12 && !F13 && !F14;
    assign Jal = OP2 && OP3 && !OP4 && OP5 && OP6;
    assign Lui = OP2 && !OP3 && OP4 && OP5 && !OP6;
    assign Lhu = !OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14;
    assign Bltu = !OP2 && !OP3 && !OP4 && OP5 && OP6 && !F12 && F13 && F14;
    assign CSRRSI = !OP2 && !OP3 && OP4 && OP5 && OP6 && !F12 && F13 && F14;
    assign CSRRCI = !OP2 && !OP3 && OP4 && OP5 && OP6 && F12 && F13 && F14;
    
endmodule
