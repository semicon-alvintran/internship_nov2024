`timescale 1ns / 1ps



module pc(
    input clk,
    input rst,
    input [31:0] inPC,
    output reg [31:0] outPC,
    output reg [31:0] outPC4

    );
    always @(posedge clk or posedge rst) 
    begin
        if (rst) begin
            outPC <= 32'h00000000;
            outPC4 <= 32'h00000000;
        end else begin
            outPC <= inPC;
            outPC4 <= inPC + 32'h00000004;
        end
    end
endmodule
