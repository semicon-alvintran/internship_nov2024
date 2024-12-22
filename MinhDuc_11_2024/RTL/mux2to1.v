`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 06:09:56 PM
// Design Name: 
// Module Name: mux2to1
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


module mux2to1(
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out

    );
    
    assign out = (sel) ? in1 : in0;
endmodule
