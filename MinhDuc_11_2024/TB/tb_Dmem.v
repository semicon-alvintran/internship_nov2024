`timescale 1ns / 1ps



module tb_Dmem;
    reg clk, reset, MemWrite, MemRead;
    reg [31:0] Address, writeData;
    wire [31:0] readData;
    
    data_memory uut(
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(Address),
        .writeData(writeData),
        .readData(readData)
        
    );
    
    //create clock pulse
    
    always #5 clk=~clk; //10ns
    
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        MemWrite = 0;
        MemRead = 0;
        Address = 32'b0;
        writeData = 32'b0;

        // Apply reset
        $display("Applying reset...");
        reset = 1;
        #10;
        reset = 0;
        #10;

        // Test Case 1: Write data to memory
        $display("Test Case 1: Write data to memory...");
        Address = 32'h00000010;  // Memory address
        writeData = 32'hDEADBEEF; // Data to write
        MemWrite = 1;  // Enable write
        #10;
        MemWrite = 0;  // Disable write
        #10;

        // Test Case 2: Read data from memory
        $display("Test Case 2: Read data from memory...");
        Address = 32'h00000010; // Same address
        MemRead = 1;  // Enable read
        #10;
        MemRead = 0;  // Disable read
        #10;

        // Test Case 3: Write to another address and verify
        $display("Test Case 3: Write to another address...");
        Address = 32'h00000020;
        writeData = 32'hCAFEBABE;
        MemWrite = 1;
        #10;
        MemWrite = 0;
        #10;

        $display("Test Case 4: Verify data at the new address...");
        Address = 32'h00000020;
        MemRead = 1;
        #10;
        MemRead = 0;
        #10;

        // Finish simulation
        $display("Testbench complete.");
        $finish;
    end
        
    
    

   
endmodule
