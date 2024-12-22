`timescale 1ns / 1ps



module tb_ctrlunit;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg brEq, brLt;
    wire branch, MemRead, MemtoReg, MemWrite, ALUsrc, RegWrite, ResultSrc;
    wire [3:0] ALUop;
    wire [2:0] immsel;
    
    
    ctrl_unit uut (
    .opcode(opcode), 
    .funct3(funct3), 
    .funct7(funct7), 
    .brEq(brEq), 
    .brLt(brLt), 
    .branch(branch), 
    .MemRead(MemRead), 
    .MemtoReg(MemtoReg), 
    .MemWrite(MemWrite), 
    .ALUsrc(ALUsrc), 
    .RegWrite(RegWrite), 
    .ResultSrc(ResultSrc), 
    .ALUop(ALUop), 
    .immsel(immsel)
    );
    
    initial begin
    // Test R-type ADD
    opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; brEq = 0; brLt = 0;
    #10;
    $display("R-type ADD: ALUop=%b, RegWrite=%b", ALUop, RegWrite);

    // Test I-type ADDI
    opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000; brEq = 0; brLt = 0;
    #10;
    $display("I-type ADDI: ALUop=%b, ALUsrc=%b", ALUop, ALUsrc);

    // Test Load (LW)
    opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000; brEq = 0; brLt = 0;
    #10;
    $display("Load LW: MemRead=%b, MemtoReg=%b", MemRead, MemtoReg);

    // Test Store (SW)
    opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000; brEq = 0; brLt = 0;
    #10;
    $display("Store SW: MemWrite=%b", MemWrite);

    // Test Branch (BEQ)
    opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; brEq = 1; brLt = 0;
    #10;
    $display("Branch BEQ: branch=%b", branch);

    $finish;

    end
        

    
endmodule
