`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2024 02:16:05 PM
// Design Name: 
// Module Name: pc_imem_tb
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


module pc_imem_tb;
    reg clk;
    reg reset;


   
    wire [31:0] outPC;   // Program Counter (PC) output
    wire [31:0] instruction, imm_out;  // Instruction fetched from instruction memory
    reg [2:0] immsel;

    // Instantiate PC (Program Counter)
    pc pc_inst (
        .clk(clk),
        .rst(reset),
        .inPC(pc_in),
        .outPC(outPC)
    );

    // Instantiate Instruction Memory (INS_MEM)
    IMem ins_mem_inst (
        .reset(reset),
        .read_address(outPC),   // Read instruction based on PC output
        .instruction_out(instruction)
    );
    
    immGen immgen (
        .ins(instruction),
        .sel(immsel),
        .imm31_0(imm_out)
    );

    // Internal signal for next PC value (PC increment logic)
    wire [31:0] pc_in;
    assign pc_in = outPC + 4;  // Increment PC by 4 for each instruction fetch

    // Testbench clock generation
    always #5 clk = ~clk;  // Clock signal with 10ns period (5ns high, 5ns low)

    // Test sequence
     initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        immsel = 3'b000;  // Set selector for I-type immediate

        // Wait for some time and then deassert reset
        #10 reset = 0;

        // Monitor the key signals
        $monitor("Time: %0d, PC: %h, Instruction: %h, Immediate: %h, immsel: %b", $time, outPC, instruction, imm_out, immsel);

        // Loop through all possible values of immsel to test different immediate types
        for (immsel = 3'b000; immsel <= 3'b111; immsel = immsel + 1) begin
            // Test for different immediate types
            #20;  // Wait for 20 time units before testing the next immsel value
        end
        
        // Run simulation for a bit longer to ensure all tests are completed
        #10;
        
        // Finish the simulation
        $finish;
    end


endmodule

