`timescale 1ns / 1ps



module immGen_tb;
    reg [31:0] ins;  // Instruction input
    reg [2:0] sel;   // Selector input for immediate type

    // Output from the immGen module
    wire [31:0] imm31_0;

    // Clock signal
    reg clk;
    immGen uut (
        .ins(ins),
        .sel(sel),
        .imm31_0(imm31_0)
    );
    
    initial begin
        clk = 0; // Initialize the clock
        forever #5 clk = ~clk; // Toggle the clock every 5 time units
    end

    // Test instruction set (you can modify these as per your needs)
    reg [31:0] instruction_memory [0:15];
    integer i;

    initial begin
        // Load instructions into memory (you can replace these with actual RISC-V instructions)
        // I-type instructions (ADDI)
        instruction_memory[0] = 32'h00000013; // NOP (ADDI x0, x0, 0)
        instruction_memory[1] = 32'h00400113; // ADDI x2, x0, 4
        instruction_memory[2] = 32'h00800193; // ADDI x3, x0, 8
        instruction_memory[3] = 32'h00C00213; // ADDI x4, x0, 12
        instruction_memory[4] = 32'h01000293; // ADDI x5, x0, 16
        instruction_memory[5] = 32'h01400313; // ADDI x6, x0, 20
        instruction_memory[6] = 32'h01800393; // ADDI x7, x0, 24
        instruction_memory[7] = 32'h01C00413; // ADDI x8, x0, 28

        // S-type instructions (SB-type example)
        instruction_memory[8] = 32'hFF000113; // SB-type (S-type instruction)
        
        // B-type instructions (Branch offset)
        instruction_memory[9] = 32'hF00FF06F; // B-type (BEQ)

        // U-type instructions (LUI)
        instruction_memory[10] = 32'h123456F3; // LUI x30, 0x123456

        // J-type instructions (JAL)
        instruction_memory[11] = 32'h000080FF; // JAL x1, 0x0 (J-type example)

        // Test other cases
        instruction_memory[12] = 32'h00600293; // ADDI x5, x0, 6
        instruction_memory[13] = 32'h00A00313; // ADDI x6, x0, 10
        instruction_memory[14] = 32'h00E00393; // ADDI x7, x0, 14
        instruction_memory[15] = 32'h01200413; // ADDI x8, x0, 18

        // Start feeding instructions on each clock cycle
        for (i = 0; i < 16; i = i + 1) begin
            // Set instruction and sel value
            ins = instruction_memory[i];
            case (i)
                // For I-type instructions (e.g., ADDI, LUI)
                0, 1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15: sel = 3'b000; // I-type
                // For S-type instructions
                8: sel = 3'b001; // S-type
                // For B-type instructions
                9: sel = 3'b010; // B-type
                // For U-type instructions (LUI)
                10: sel = 3'b011; // U-type
                // For J-type instructions (JAL)
                11: sel = 3'b100; // J-type
                default: sel = 3'b000; // Default to I-type
            endcase

            // Wait for one clock cycle
            @(posedge clk);
        end

        // End simulation after all instructions are processed
        #10 $finish;
    end

    // Monitor the output
    initial begin
        $monitor("At time %t, ins = %h, sel = %b, imm31_0 = %h", $time, ins, sel, imm31_0);
    end


   
endmodule
