`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2024 10:31:47 PM
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
