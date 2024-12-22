`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2024 10:36:28 PM
// Design Name: 
// Module Name: IMem
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


module IMem(
    input reset,
    input [31:0] read_address,
    output [31:0] instruction_out
);

    reg [31:0] Memory [63:0];  // 64 words of instruction memory (4-byte per word)
    integer i;
    initial begin
        //integer i;
        $readmemh("instruction.mem", Memory);
        
        // Add display statements to verify initialization
        for (i = 0; i < 10; i = i + 1) begin
            $display("Memory[%0d] = %h", i, Memory[i]);
        end
    end

    
    // Use word-aligned address (divide by 4, or use the upper bits of address)
    assign instruction_out = Memory[read_address>>2];

   
endmodule
