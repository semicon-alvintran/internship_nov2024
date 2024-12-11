`timescale 1ns/1ps

module clock_divide_tb;

  // Inputs
  logic clk;
  logic rst_n;
  logic [6:0] address;
  logic [7:0] writedata;

  // Outputs
  logic clk_out;

  // Clock signal generation
  localparam CLK_PERIOD = 100; // Clock period in ns (100 MHz)
  initial clk = 0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  // Instantiate the DUT (Device Under Test)
  clock_divide uut (
    .clk(clk),
    .rst_n(rst_n),
    .address(address),
    .writedata(writedata),
    .clk_out(clk_out)
  );

  // Testbench variables
  initial begin
    $display("Starting testbench");

    // Initialize inputs
    rst_n = 0;
    address = 0;
    writedata = 0;

    // Reset the DUT
    #20 rst_n = 1;

    address = 7'd1;
    writedata = 8'd25; // Example input for division
    #9000;

    // Finish simulation
    $stop;
  end

  // Monitor signals
  initial begin
    $monitor($time, " clk=%b rst_n=%b address=%0d writedata=%0d clk_out=%b", 
             clk, rst_n, address, writedata, clk_out);
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule