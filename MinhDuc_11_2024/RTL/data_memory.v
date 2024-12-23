`timescale 1ns / 1ps



module data_memory(
    input clk, reset, MemWrite, MemRead,
    input [31:0] Address, writeData,
    output reg [31:0] readData
    );
     
    reg [31:0] Dmemory [63:0];  
    wire [5:0] memAddress = Address[7:2];  
    integer i;
    //assign readData = (MemRead) ? Dmemory[memAddress] : 32'h0;
    //integer i;
    always @(*) begin   
        if(MemRead) begin   
            readData = Dmemory[memAddress];
        end 
        else begin
            readData = 32'h0;
        end
    end
    always @ (posedge clk or posedge reset) begin
        if(reset) begin
            for(i = 0; i < 64; i = i + 1) begin
                Dmemory[i] <= 32'h0;  
            end
        end
        else if(MemWrite) begin
            Dmemory[memAddress] <= writeData;  
        end
    end
endmodule

