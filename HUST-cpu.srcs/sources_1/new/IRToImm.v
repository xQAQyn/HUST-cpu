`timescale 1ns / 1ps

module IRToImm(
    input wire[31:0] IR,
    output reg[31:0] Imm
);
    
    wire [31:0] TypeU, TypeI, TypeS, TypeB, TypeJ;
    
    assign TypeU = {IR[31:12], 12'b0};
    bitExtend #(.inWidth(12), .outWidth(32)) ExtendI (IR[31:20], TypeI);
    bitExtend #(.inWidth(12), .outWidth(32)) ExtendS ({IR[31:25],IR[11:7]}, TypeS);
    bitExtend #(.inWidth(13), .outWidth(32)) ExtendB ({IR[31], IR[7], IR[30:25], IR[11:8], 1'b0}, TypeB);
    bitExtend #(.inWidth(21), .outWidth(32)) ExtendJ ({IR[31], IR[19:12], IR[20], IR[30:21], 1'b0}, TypeJ);
    
    always @(*) begin
        case(IR[6:2])
            5'h18: Imm <= TypeB;
            
            5'h00, 5'h04, 5'h1c, 5'h19: begin
                if(IR[6:2] == 5'h04 && (IR[14:12] == 5 || IR[14:12] == 1))
                    Imm <= IR[24:20];
                else
                    Imm <= TypeI;
            end
            
            5'h0d: Imm <= TypeU;
            
            5'h08: Imm <= TypeS;
            
            default: Imm <= TypeJ;
        endcase
    end
endmodule
