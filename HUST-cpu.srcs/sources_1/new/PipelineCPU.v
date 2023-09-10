`timescale 1ns / 1ps

module PipelineCPU(
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
    output W3,
    output reg handleInteruption
);

    reg [31:0] RDin;
    wire [31:0] BranchAddr;
    wire JumpToBranch;
    
    reg [31:0] IF_PC, EPC;
    wire [31:0] IF_IR;
    
    wire [31:0] ID_PC, ID_IR, ID_R1, ID_R2, ID_Imm;
    wire ID_MemToReg, ID_MemWrite, ID_ALU_SRC, ID_RegWrite, ID_uret, ID_ecall, ID_Beq, ID_Bne, ID_Jalr, ID_Jal, ID_Lui, ID_Lhu, ID_Bltu, ID_CSRRSI, ID_CSRRCI, ID_Load, ID_LoadUse;
    wire [1:0] ID_R1Control, ID_R2Control;
    wire [3:0] ID_ALUop;
    wire [4:0] ID_WR;
    wire ID_pause;
    
    wire [31:0] EX_PC, EX_IR, EX_R1raw, EX_R2raw, EX_Imm, EX_ALUResult;
    reg [31:0] EX_R1, EX_R2;
    wire EX_MemToReg, EX_MemWrite, EX_ALU_SRC, EX_RegWrite, EX_uret, EX_ecall, EX_Beq, EX_Bne, EX_Jalr, EX_Jal, EX_Lui, EX_Lhu, EX_Bltu, EX_CSRRSI, EX_CSRRCI, EX_Load, EX_Jtype;
    wire [1:0] EX_R1Control, EX_R2Control;
    wire [3:0] EX_ALUop;
    wire [4:0] EX_WR;
    
    wire [31:0] MEM_PC, MEM_IR, MEM_R2, MEM_ALUResult, MEM_Data;
    wire MEM_MemWrite, MEM_Jtype, MEM_MemToReg, MEM_RegWrite, MEM_Lui, MEM_Lhu, MEM_Load;
    wire [4:0] MEM_WR;
    
    wire [31:0] WB_PC, WB_IR, WB_Data, WB_ALUResult;
    wire WB_Jtype, WB_MemToReg, WB_RegWrite, WB_Lui, WB_Lhu;
    wire [4:0] WB_WR;
    
    wire IntOn, IntOff, IntR, Int;
    reg IntE, IntCLR;
    wire [1:0] IntNo;
    reg [31:0] IntAddr;
    
// IF Implement
    initial begin
        IF_PC <= 0;
        EPC <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IF_PC <= 0;
        end
        else if(halt) begin
            IF_PC <= IF_PC;
            $display("PC:halted at %h", IF_PC);
        end
        else if(Int == 1'b1) begin
            IF_PC <= IntAddr;
            handleInteruption <= 1;
        end
        else if(EX_uret) begin
            IF_PC <= EPC;
            handleInteruption <= 0;
        end
        else if(ID_LoadUse) begin
            IF_PC <= IF_PC;
            $display("PC:halted at %h", IF_PC);
        end
        else if(JumpToBranch) begin
            IF_PC <= BranchAddr;
            $display("PC:Jump to branch");
        end
        else begin
            IF_PC <= IF_PC + 4;
            $display("PC:next instruction");
        end
    end
    IROM InstructionROM(
        .addr(IF_PC[11:2]),
        .IR(IF_IR)
    );
    
// IF/ID interface
    assign IF_ID_rst = JumpToBranch || Int || EX_uret || rst;
    IF_ID_Interface IF_ID(
      .IF_PC(IF_PC),
      .IF_IR(IF_IR),
      .ID_PC(ID_PC),
      .ID_IR(ID_IR),
      .stall(!ID_LoadUse),
      .clk(clk),
      .pause(ID_pause),
      .rst(IF_ID_rst)
    );

// ID Implement
    PipelineControler Controler(
        .IR(ID_IR),
        .EX_Load(EX_Load),
        .MEM_Load(MEM_Load),
        .EX_RegWrite(EX_RegWrite),
        .MEM_RegWrite(MEM_RegWrite),
        .EX_WR(EX_WR),
        .MEM_WR(MEM_WR),
        .ALUop(ID_ALUop),
        .MemToReg(ID_MemToReg),
        .MemWrite(ID_MemWrite),
        .ALU_SRC(ID_ALU_SRC),
        .RegWrite(ID_RegWrite),
        .uret(ID_uret),
        .ecall(ID_ecall),
        .Beq(ID_Beq),
        .Bne(ID_Bne),
        .Jalr(ID_Jalr),
        .Jal(ID_Jal),
        .Lui(ID_Lui),
        .Lhu(ID_Lhu),
        .Bltu(ID_Bltu),
        .CSRRSI(ID_CSRRSI),
        .CSRRCI(ID_CSRRCI),
        .Load(ID_Load),
        .WR(ID_WR),
        .LoadUse(ID_LoadUse),
        .R1Control(ID_R1Control),
        .R2Control(ID_R2Control)
    );
    
    IRToImm ImmGen(
        .IR(ID_IR),
        .Imm(ID_Imm)
    );
    
    wire [4:0] ID_RS1, ID_RS2;
    assign ID_RS1 = ID_ecall == 1 ? 5'h11 : ID_IR[19:15];
    assign ID_RS2 = ID_ecall == 1 ? 5'h0a : ID_IR[24:20];
    downRegFile register(
        .rs1(ID_RS1), 
        .rs2(ID_RS2), 
        .R1(ID_R1),
        .R2(ID_R2),
        .WE(WB_RegWrite),
        .clk(clk),
        .RDin(RDin),
        .WR(WB_WR),
        .rst(rst)
    );

// ID/EX interface
    wire EX_rst;
    assign EX_rst = ID_pause || EX_uret || Int || JumpToBranch || rst;
    ID_EX_Interface ID_EX(
        .ID_PC(ID_PC),
        .ID_IR(ID_IR),
        .ID_ALUop(ID_ALUop),
        .ID_WR(ID_WR),
        .ID_MemToReg(ID_MemToReg),
        .ID_MemWrite(ID_MemWrite),
        .ID_ALU_SRC(ID_ALU_SRC),
        .ID_RegWrite(ID_RegWrite),
        .ID_uret(ID_uret),
        .ID_ecall(ID_ecall),
        .ID_Beq(ID_Beq),
        .ID_Bne(ID_Bne),
        .ID_Jalr(ID_Jalr),
        .ID_Jal(ID_Jal),
        .ID_Lui(ID_Lui),
        .ID_Lhu(ID_Lhu),
        .ID_Bltu(ID_Bltu),
        .ID_CSRRSI(ID_CSRRSI),
        .ID_CSRRCI(ID_CSRRCI),
        .ID_Load(ID_Load),
        .ID_R1Control(ID_R1Control),
        .ID_R2Control(ID_R2Control),
        .ID_R1(ID_R1),
        .ID_R2(ID_R2),
        .ID_Imm(ID_Imm),
        
        .EX_PC(EX_PC),
        .EX_IR(EX_IR),
        .EX_ALUop(EX_ALUop),
        .EX_WR(EX_WR),
        .EX_MemToReg(EX_MemToReg),
        .EX_MemWrite(EX_MemWrite),
        .EX_ALU_SRC(EX_ALU_SRC),
        .EX_RegWrite(EX_RegWrite),
        .EX_uret(EX_uret),
        .EX_ecall(EX_ecall),
        .EX_Beq(EX_Beq),
        .EX_Bne(EX_Bne),
        .EX_Jalr(EX_Jalr),
        .EX_Jal(EX_Jal),
        .EX_Lui(EX_Lui),
        .EX_Lhu(EX_Lhu),
        .EX_Bltu(EX_Bltu),
        .EX_CSRRSI(EX_CSRRSI),
        .EX_CSRRCI(EX_CSRRCI),
        .EX_Load(EX_Load),
        .EX_R1Control(EX_R1Control),
        .EX_R2Control(EX_R2Control),
        .EX_R1(EX_R1raw),
        .EX_R2(EX_R2raw),
        .EX_Imm(EX_Imm),
        
        .clk(clk),
        .rst(EX_rst)
    );

// EX Implement
    // Redirect R1 and R2
    always @(*) begin
        case(EX_R1Control)
            2'b00: begin
                EX_R1 <= EX_R1raw;
            end
            2'b01: begin
                EX_R1 <= MEM_ALUResult;
            end
            2'b10: begin
                EX_R1 <= WB_ALUResult;
            end
            2'b11: begin
                EX_R1 <= WB_Data;
            end
        endcase
        
        case(EX_R2Control)
            2'b00: begin
                EX_R2 <= EX_R2raw;
            end
            2'b01: begin
                EX_R2 <= MEM_ALUResult;
            end
            2'b10: begin
                EX_R2 <= WB_ALUResult;
            end
            2'b11: begin
                EX_R2 <= WB_Data;
            end
        endcase
    end
    
    // Set ALU
    reg [31:0] ALUy;
    always @(*) begin
        if(EX_ALU_SRC) begin
            ALUy <= EX_Imm;
        end
        else if(EX_ecall) begin
            ALUy <= 32'h22;
        end
        else begin
            ALUy <= EX_R2;
        end
    end
    wire EX_equal, EX_ge, EX_less;
    ALU alu(
        .x(EX_R1),
        .y(ALUy),
        .ALUop(EX_ALUop),
        .result1(EX_ALUResult),
        .equal(EX_equal),
        .ge(EX_ge),
        .less(EX_less)
    );
    
    //handle ecall
    always @(posedge clk or posedge rst or posedge Go) begin
        if(rst) begin
            halt <= 1'b0;
            LEDInfo <= 32'b0;
        end
        else if(Go) begin
            halt <= 1'b0;
        end
        else if(EX_ecall && EX_equal) begin
            LEDInfo <= EX_R2;
        end
        else if(EX_ecall && !EX_equal) begin
            halt <= 1'b1;
            LEDInfo <= EX_PC;
        end
    end
    
    // handle branch
    assign BranchAddr = (EX_Jalr == 1'b1) ? ((EX_R1 + EX_Imm) & 32'hfffffffe) : (EX_PC + EX_Imm);
    assign JumpToBranch = EX_Jal == 1'b1 || EX_Jalr == 1'b1 || (EX_Bltu && EX_less) || (EX_Beq && EX_equal) || (EX_Bne && !EX_equal);

    // handle interruption
    assign IntOn = EX_uret || EX_CSRRSI;
    assign IntOff = Int || EX_CSRRCI;
    assign Int = !IntE && IntR;
    always @(posedge clk) begin
        if(rst) EPC <= 0;
        else if(Int) begin
            if(JumpToBranch)
                EPC <= BranchAddr;
            else
                EPC <= ID_PC;
        end
        
        if(rst) IntE <= 0;
        else if(IntOn)
            IntE <= 0;
        else if(IntOff)
            IntE <= 1;
    end
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
        case (IntNo)
            2'b01 : IntAddr <= 32'h30ac;
            2'b10 : IntAddr <= 32'h3150;
            2'b11 : IntAddr <= 32'h31f4;
            default: IntAddr <= 32'h0;
        endcase
    end

// EX/MEM interface
    wire [31:0] EX_MEM_ALUResult;
    assign EX_MEM_ALUResult = (EX_Lui == 1'b1) ? EX_Imm : EX_ALUResult;
    assign EX_Jtype = EX_Jal || EX_Jalr;
    EX_MEM_Interface EX_MEM(
        .EX_PC(EX_PC),
        .EX_IR(EX_IR),
        .EX_MemWrite(EX_MemWrite),
        .EX_R2(EX_R2),
        .EX_Jtype(EX_Jtype),
        .EX_ALUResult(EX_MEM_ALUResult),
        .EX_MemToReg(EX_MemToReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_Lhu(EX_Lhu),
        .EX_WR(EX_WR),
        .EX_Load(EX_Load),
        
        .MEM_PC(MEM_PC),
        .MEM_IR(MEM_IR),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_R2(MEM_R2),
        .MEM_Jtype(MEM_Jtype),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_Lhu(MEM_Lhu),
        .MEM_WR(MEM_WR),
        .MEM_Load(MEM_Load),
        
        .clk(clk),
        .rst(rst)
    );

// MEM Implement
    RAM Memory(
        .Addr(MEM_ALUResult[9:0]),
        .MRin(MEM_R2),
        .WE(MEM_MemWrite),
        .CLK(clk),
        .Data(MEM_Data),
        .mode(MEM_Lhu)
    );

// MEM/WB interface
    MEM_WB_Interface MEM_WB(
        .MEM_PC(MEM_PC),
        .MEM_IR(MEM_IR),
        .MEM_Data(MEM_Data),
        .MEM_Jtype(MEM_Jtype),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_WR(MEM_WR),
        
        .WB_PC(WB_PC),
        .WB_IR(WB_IR),
        .WB_Data(WB_Data),
        .WB_Jtype(WB_Jtype),
        .WB_ALUResult(WB_ALUResult),
        .WB_MemToReg(WB_MemToReg),
        .WB_RegWrite(WB_RegWrite),
        .WB_WR(WB_WR),
        
        .clk(clk),
        .rst(rst)
    );

// WB Implement
    always @(*) begin
        if(WB_MemToReg) begin
            RDin <= WB_Data;
            $display("RDin: from memory");
        end
        else if(WB_Jtype) begin
            RDin <= WB_PC + 4;
            $display("RDin: from PC+4");
        end
        else begin
            RDin <= WB_ALUResult;
            $display("RDin: from ALU");
        end
    end

endmodule
