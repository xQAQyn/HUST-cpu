`timescale 1ns / 1ps

module RegFile(
    input wire[4:0] rs1, 
    input wire[4:0] rs2, 
    output wire[31:0] R1,
    output wire[31:0] R2,
    input wire WE,
    input wire clk,
    input wire[31:0] RDin,
    input wire[4:0] WR,
    input rst
);

    reg[31:0] x[31:0];
    
    initial begin
        for(i = 0;i < 32;i=i+1)
            x[i] <= 32'b0;
    end
    
    integer i;
    
    assign R1 = x[rs1];
    assign R2 = x[rs2];
    
    always @ (posedge clk or posedge rst) begin
        $display("WE:%h, WR:%h, RDin:%h",WE,WR,RDin);
        if(rst)begin
            for(i = 0;i < 32;i=i+1)
                x[i] <= 32'b0;
        end
        else if(WE == 1 && WR != 0) begin
            x[WR] <= RDin;
        end
    end

endmodule
