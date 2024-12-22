`timescale 1ns / 1ps



module tb_alu;
    reg [31:0] op1, op2;
    reg [3:0] alu_sel;
    wire [31:0] alu_out;
    wire zero, carry, overflow;

    // Instantiate the ALU module
    alu uut (
        .op1(op1),
        .op2(op2),
        .alu_sel(alu_sel),
        .alu_out(alu_out),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    // Testbench process
    initial begin
        $monitor("Time: %0t | op1: %h | op2: %h | alu_sel: %b | alu_out: %h | zero: %b | carry: %b | overflow: %b", 
                 $time, op1, op2, alu_sel, alu_out, zero, carry, overflow);

        // Test Addition
        op1 = 32'h00000010; op2 = 32'h00000020; alu_sel = 4'b0000; #10; // Expect alu_out = 0x30, carry = 0, overflow = 0

        // Test Subtraction
        op1 = 32'h00000020; op2 = 32'h00000010; alu_sel = 4'b0001; #10; // Expect alu_out = 0x10, carry = 0, overflow = 0

        // Test Logical AND
        op1 = 32'hF0F0F0F0; op2 = 32'h0F0F0F0F; alu_sel = 4'b0100; #10; // Expect alu_out = 0x00000000

        // Test Logical OR
        op1 = 32'hF0F0F0F0; op2 = 32'h0F0F0F0F; alu_sel = 4'b0101; #10; // Expect alu_out = 0xFFFFFFFF

        // Test Logical XOR
        op1 = 32'hAAAAAAAA; op2 = 32'h55555555; alu_sel = 4'b0110; #10; // Expect alu_out = 0xFFFFFFFF

        // Test Left Shift
        op1 = 32'h00000001; op2 = 32'h00000002; alu_sel = 4'b1000; #10; // Expect alu_out = 0x00000004

        // Test Logical Right Shift
        op1 = 32'h00000004; op2 = 32'h00000001; alu_sel = 4'b1001; #10; // Expect alu_out = 0x00000002

        // Test Arithmetic Right Shift
        op1 = 32'h80000000; op2 = 32'h00000001; alu_sel = 4'b1010; #10; // Expect alu_out = 0xC0000000

        // Test Unsigned Less Than Comparison
        op1 = 32'h00000010; op2 = 32'h00000020; alu_sel = 4'b1100; #10; // Expect alu_out = 0x00000001

        // Test Equality Comparison
        op1 = 32'h00000020; op2 = 32'h00000020; alu_sel = 4'b1101; #10; // Expect alu_out = 0x00000001

        // Test Overflow
        op1 = 32'h7FFFFFFF; op2 = 32'h00000001; alu_sel = 4'b0000; #10; // Expect overflow = 1

        $finish;
    end

    
endmodule
