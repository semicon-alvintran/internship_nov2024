`timescale 1ns/1ps

module start_gen_tb;

  // Testbench signals
  logic clk;
  logic rst_n;
  logic rd;
  logic wr;
  logic cs;

  logic start;
  logic rw;

  // Instantiate the design under test (DUT)
  start_gen dut (
    .clk(clk),
    .rst_n(rst_n),
    .rd(rd),
    .wr(wr),
    .cs(cs),
    .start(start),
    .rw(rw)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period
  end

  // Stimulus
  initial begin
    // Initialize inputs
    rst_n = 0;
    rd = 0;
    wr = 0;
    cs = 0;

    // Reset
    #10 rst_n = 1;
	
    cs = 1;
    wr = 1;
    #10;
    cs = 0;
    wr = 0;
    
    #10;
    cs = 1;
    rd = 1;
    #10;
    cs = 0;
    rd = 0;
    // End simulation
    #50 $stop;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | rst_n=%b | rd=%b | wr=%b | cs=%b | start=%b | rw=%b", 
             $time, rst_n, rd, wr, cs, start, rw);
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule
