`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2024 09:52:43 PM
// Design Name: 
// Module Name: RegFlile
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


module RegFile(
    input clk,
    input rst,
    input RegW,
    input [4:0] Rs1,
    input [4:0] Rs2,
    input [4:0] Rd,
    input [31:0] Wd,
    output [31:0] rd1,
    output [31:0] rd2

    );
   
    reg [31:0] Registers [31:0];
    //integer i;
    assign rd1 = Registers[Rs1];
    assign rd2 = Registers[Rs2];
    
//    always @(posedge clk or posedge rst) begin  
//        if (rst) begin
//            // All register reset
            
//            for (i = 0; i < 32 ; i = i + 1) begin
//                regs[i] <= 32'b0;
//            end
//        end 
//        else if ( regwrite && write_reg != 5'b0) begin
//            regs[write_reg] <= write_data;
//        end
//    end
     
//     assign read_data1 = (read_reg1 != 5'b0) ? regs[read_reg1] : 32'b0;
//     assign read_data2 = (read_reg2 != 5'b0) ? regs[read_reg2] : 32'b0;
    // initialization in simulation
    
    initial begin   
        Registers[0] = 32'b0; // Register 0 is hardwired to 0 in RISC-V
        Registers[1] = 32'b0;
        Registers[2] = 32'b0;
        Registers[3] = 32'b0;
        Registers[4] = 32'b0;
        Registers[5] = 32'b0;
        Registers[6] = 32'b0;
        Registers[7] = 32'b0;
        Registers[8] = 32'b0;
        Registers[9] = 32'b0;
        Registers[10] = 32'b0;
        Registers[11] = 32'b0;
        Registers[12] = 32'b0;
        Registers[13] = 32'b0;
        Registers[14] = 32'b0;
        Registers[15] = 32'b0;
        Registers[16] = 32'b0;
        Registers[17] = 32'b0;
        Registers[18] = 32'b0;
        Registers[19] = 32'b0;
        Registers[20] = 32'b0;
        Registers[21] = 32'b0;
        Registers[22] = 32'b0;
        Registers[23] = 32'b0;
        Registers[24] = 32'b0;
        Registers[25] = 32'b0;
        Registers[26] = 32'b0;
        Registers[27] = 32'b0;
        Registers[28] = 32'b0;
        Registers[29] = 32'b0;
        Registers[30] = 32'b0;
        Registers[31] = 32'b0;
    end
    always @(posedge clk) begin 
        if (RegW == 1'b1 && Rd != 5'b00000) begin
            Registers[Rd] <= Wd; // Write to register Rd with value Wd
            $display("Register %d updated to %h", Rd, Wd);
        end
    end
    // Register file: 32 registers, each 32 bits wide
//    reg [31:0] Registers [31:0];
//    integer i; // Declare integer for loops

//    // Assign read values
//    assign rd1 = (Rs1 != 5'b00000) ? Registers[Rs1] : 32'b0;  // Read from Rs1
//    assign rd2 = (Rs2 != 5'b00000) ? Registers[Rs2] : 32'b0;  // Read from Rs2

//    // Initialize registers (only for simulation)
//    initial begin
//        for (i = 0; i < 32; i = i + 1) begin
//            Registers[i] = 32'b0;
//        end
//    end

//    // Write logic
//    always @(posedge clk or posedge rst) begin
//        if (rst) begin
//            // Reset all registers to 0
//            for (i = 0; i < 32; i = i + 1) begin
//                Registers[i] <= 32'b0;
//            end
//        end else if (RegW == 1'b1 && Rd != 5'b00000) begin
//            Registers[Rd] <= Wd; // Write to register Rd
//            $display("Register %d updated to %h", Rd, Wd); // Debug message
//        end
//    end
                
                
endmodule
