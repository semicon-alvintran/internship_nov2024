`timescale 1ns / 1ps



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
