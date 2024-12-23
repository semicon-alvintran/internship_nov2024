`timescale 1ns / 1ps



module cpu_tb;
    // Inputs
    reg clk;
    reg reset;

// Internal signals
    wire [31:0] PCp4, outPC;            
    wire [31:0] instruction;             
    wire [31:0] alu_result, mem_data;    
    wire [31:0] read_data1, read_data2;  
    wire [31:0] imm_out, bsel;           
    wire [3:0] ALUop;                   
    wire [31:0] ResultMux;
    wire branch, MemRead, MemtoReg, MemWrite, ALUsrc, RegWrite, ResultSrc; 
    wire zero, carry, overflow, PCSrc;   
    wire brEq, brLt;                     
    wire brUn;                           
    wire [2:0] immsel;
    // PC-related signals
    wire [31:0] pc_in, pc_out;
    
    // Signals from instruction fields
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd = instruction[11:7];
    
    cpu uut(
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        clk = 1;
        forever #10 clk = ~clk;
    end

    // Reset generation
    initial begin
        reset = 1; 
        #20;        
        reset = 0; 
        #480;      
    $finish;    
    end

    
endmodule
