`timescale 1ns / 1ps

module SingleCycleCPU(
    input IR1,
    input IR2,
    input IR3,
    input Go,
    input wire clk,
    input rst,
    output reg[31:0] LEDInfo,
    output reg halt,
    output W1,
    output W2,
    output W3
);
    reg[31:0] EPC,PC,RDin;
    initial begin
        PC <= 0;
        EPC <= 0;
    end
    
    wire[31:0] IR;
    wire RegWrite,MemWrite;
    
    wire Jal, Jalr, uret, CSRRSI, CSRRCI, Beq, Bne, MemToReg, ALU_SRC, ecall, Lui, Lhu, Bltu;
    wire ge, equal, less;
    wire [3:0] ALUop;
    
    wire [31:0] branchAddr;
    wire [31:0] R1, R2, Imm;
    wire Int;
    reg [31:0] IntAddr;
    wire [1:0] IntNo;
    
    // get and update PC and IR
    IROM InstructionROM(
        .addr(PC[11:2]),
        .IR(IR)
    );
    assign branchAddr = (Jalr == 1'b1) ? ((R1 + Imm) & 32'hfffffffe) : (PC + Imm);
    always @(posedge clk or posedge rst) begin
        if(rst)
            PC <= 0;
        else if(halt == 1'b1) begin
            PC <= PC;
            $display("PC: halted");
        end
        else if(Int == 1'b1) begin
            PC <= IntAddr;
            $display("PC: handle interuption");
        end
        else if(uret == 1'b1) begin
            PC <= EPC;
            $display("PC: return from interuption");
        end
        else if(Jal == 1'b1 || Jalr == 1'b1 || (Bltu && less) || (Beq && equal) || (Bne && !equal)) begin
            PC <= branchAddr;
            $display("PC: jump to branch, Imm: %h",Imm);
        end
        else begin
            PC <= PC + 4;
            $display("PC: next instruction");
        end
    end
    
    SingleCycleControler Controler(
        .IR(IR),
        .ALUop(ALUop),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALU_SRC(ALU_SRC),
        .RegWrite(RegWrite),
        .uret(uret),
        .ecall(ecall),
        .Beq(Beq),
        .Bne(Bne),
        .Jalr(Jalr),
        .Jal(Jal),
        .Lui(Lui),
        .Lhu(Lhu),
        .Bltu(Bltu),
        .CSRRSI(CSRRSI),
        .CSRRCI(CSRRCI)
    );
    
    IRToImm ImmGen(
        .IR(IR),
        .Imm(Imm)
    );
    
    // Register set
    wire[4:0] RS1, RS2;
    assign RS1 = ecall == 1 ? 5'h11 : IR[19:15];
    assign RS2 = ecall == 1 ? 5'h0a : IR[24:20];
    
    wire [31:0] MDout;
    wire [31:0] ALUResult;
    always @(*) begin
        if(Lui)
            RDin <= Imm;
        else if(Jal || Jalr)
            RDin <= PC+4;
        else if(MemToReg)
            RDin <= MDout;
        else
            RDin <= ALUResult;
    end
    RegFile Registers(
        .rs1(RS1), 
        .rs2(RS2), 
        .R1(R1),
        .R2(R2),
        .WE(RegWrite),
        .clk(clk),
        .RDin(RDin),
        .WR(IR[11:7])
    );
    
    // ALU set
    reg [31:0] ALUy;
    always @(*) begin
        if(ecall)
            ALUy <= 32'h22;
        else if(ALU_SRC)
            ALUy <= Imm;
        else
            ALUy <= R2;
    end
    ALU alu(
        .x(R1),
        .y(ALUy),
        .ALUop(ALUop),
        .result1(ALUResult),
        .equal(equal),
        .ge(ge),
        .less(less)
    );

    // Memory set
    RAM Memory(
        .Addr(ALUResult[9:0]),
        .MRin(R2),
        .WE(MemWrite),
        .CLK(clk),
        .Data(MDout),
        .mode(Lhu)
    );

    // ecall handler
    always @(negedge clk or posedge Go or posedge rst) begin
        if(rst) LEDInfo <= 0;
        else if(Go) halt <= 0;
        else if(ecall) begin
            if(equal)
                LEDInfo <= R2;
            else
                halt <= 1;
        end
    end

    // Interruption handler
    wire IntOn, IntOff, IntR;
    reg IntE;
    assign IntOn = uret || CSRRSI;
    assign IntOff = Int || CSRRCI;
    assign Int = !IntE && IntR;
    always @(posedge clk or posedge rst) begin
        if(rst) EPC <= 0;
        else if(Int) begin
            if(Jal == 1'b1 || Jalr == 1'b1 || (Bltu && less) || (Beq && equal) || (Bne && !equal))
                EPC <= branchAddr;
            else
                EPC <= PC + 4;
        end

        if(rst) IntE <= 0;
        else if(IntOn)
            IntE <= 0;
        else if(IntOff)
            IntE <= 1;
    end
    reg IntCLR;
    always @(posedge clk) begin
        if(Int == 1'b1)
            IntCLR <= 1;
        else IntCLR <= 0;
    end
    IntController IntControl(
        .IR1(IR1),
        .IR2(IR2),
        .IR3(IR3),
        .CLR(IntCLR),
        .clk(clk),
        .rst(rst),
        .W1(W1),
        .W2(W2),
        .W3(W3),
        .IntNo(IntNo),
        .IntR(IntR)
    );
    always @(IntNo) begin
        case(IntNo) 
            2'b01 : IntAddr <= 32'h30ac;
            2'b10 : IntAddr <= 32'h3150;
            2'b11 : IntAddr <= 32'h31f4;
            default: IntAddr <= 32'h0;
        endcase
    end
    
endmodule