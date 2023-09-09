`timescale 1ns / 1ps

module PipelineControler(
    input wire[31:0] IR,
    input  EX_Load,
    input  MEM_Load,
    input  EX_RegWrite,
    input  MEM_RegWrite,
    input [4:0]  EX_WR,
    input [4:0]  MEM_WR,
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
    output CSRRCI,
    output Load,
    output [4:0] WR,
    output LoadUse,
    output reg[1:0] R1Control,
    output reg[1:0] R2Control
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
    
    assign WR = IR[11:7];
    assign Load = (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && !F12 && F13 && !F14) || (!OP2 && !OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14);
    
    wire [4:0] R1, R2;
    assign R1 = (ecall == 1'b0) ? IR[19:15] : 5'h11;
    assign R2 = (ecall == 1'b0) ? IR[24:20] : 5'h0a;
    
    wire ReadR1, ReadR2;
    assign ReadR1 = (!OP3 && !OP4 && !OP6 && !F12 && F13 && !F14 && !OP2) || (!OP3 && !OP4 && !OP5 && !OP6 && F12 && !F13 && F14 && !OP2) || (!OP3 && !OP4 && OP5 && OP6 && !F12 && !F13 && !F14) || (!OP3 && !OP4 && OP5 && OP6 && !F13 && !F14 && !OP2) || (!OP3 && !OP4 && OP5 && OP6 && !F12 && F13 && F14 && !OP2) || (!OP3 && OP4 && !OP5 && !OP6 && !F12 && !OP2) || (!OP3 && OP4 && !OP5 && !OP6 && !F25 && !F30 && !OP2) || (!OP3 && OP4 && !OP6 && !F12 && !F13 && !F14 && !F25 && !OP2) || (!OP3 && OP4 && !OP5 && !OP6 && F14 && !F25 && !OP2) || (!OP3 && OP4 && !OP5 && !OP6 && F13 && !OP2) || (!OP3 && OP4 && !OP6 && F13 && !F25 && !F30 && !OP2) || (!OP3 && OP4 && OP5 && !F12 && !F13 && !F14 && !F25 && !F30 && !OP2);
    assign ReadR2 = (!OP3 && !OP4 && OP5 && !OP6 && !F12 && F13 && !F14 && !OP2) || (!OP3 && !OP4 && OP5 && OP6 && !F13 && !F14 && !OP2) || (!OP3 && !OP4 && OP5 && OP6 && !F12 && F13 && F14 && !OP2) || (!OP3 && OP4 && OP5 && !OP6 && !F12 && !F13 && !F14 && !F25 && !OP2) || (!OP3 && OP4 && OP5 && !F12 && !F13 && !F14 && !F25 && !F30 && !OP2) || (!OP3 && OP4 && OP5 && !OP6 && F13 && !F25 && !F30 && !OP2);

    wire  EX_Conf_R1,  EX_Conf_R2,  MEM_Conf_R1,  MEM_Conf_R2;
    assign  EX_Conf_R1 = ( EX_WR == R1) &&  EX_RegWrite;
    assign  EX_Conf_R2 = ( EX_WR == R2) &&  EX_RegWrite;
    assign  MEM_Conf_R1 = ( MEM_WR == R1) &&  MEM_RegWrite;
    assign  MEM_Conf_R2 = ( MEM_WR == R2) &&  MEM_RegWrite;
    
    assign LoadUse = ( EX_Conf_R1 ||  EX_Conf_R2) &&  EX_Load;
    
    always @(IR) begin
        $display("IR:%d",IR);
        $display("R1:%h, EX_WR:%h, EX_RegWrite:%h, ReadR1:%h, EX Conflict R1: %h", R1, EX_WR, EX_RegWrite, ReadR1, EX_Conf_R1);
        $display("R2:%h, EX_WR:%h, EX_RegWrite:%h, ReadR2:%h, EX Conflict R2: %h", R2, EX_WR, EX_RegWrite, ReadR2, EX_Conf_R2);
        $display("R1:%h, MEM_WR:%h, MEM_RegWrite:%h, ReadR1:%h, MEM Conflict R1: %h", R1, MEM_WR, MEM_RegWrite, ReadR1, MEM_Conf_R1);
        $display("R2:%h, MEM_WR:%h, MEM_RegWrite:%h, ReadR2:%h, MEM Conflict R2: %h", R2, MEM_WR, MEM_RegWrite, ReadR2, MEM_Conf_R2);
    end
    
    always @(*) begin
        if( EX_Conf_R1 == 1'b0 && MEM_Conf_R1 == 1'b0)
            R1Control <= 2'h0;
        else if( EX_Conf_R1 == 1'b1 && EX_Load == 1'b1)
            R1Control <= 2'h1;
        else if( EX_Conf_R1 == 1'b0 &&  MEM_Conf_R1 == 1'b1 && MEM_Load == 1'b0)
            R1Control <= 2'h2;
        else
            R1Control <= 2'h3;
            
        if( EX_Conf_R2 == 1'b0 && MEM_Conf_R2 == 1'b0)
            R2Control <= 2'h0;
        else if( EX_Conf_R2 == 1'b1 && EX_Load == 1'b1)
            R2Control <= 2'h1;
        else if( EX_Conf_R2 == 1'b0 &&  MEM_Conf_R2 == 1'b1 && MEM_Load == 1'b0)
            R2Control <= 2'h2;
        else
            R2Control <= 2'h3;;
    end
    
endmodule
