`timescale 1ns/1ps
module shift_register_tb;
    // Testbench signals
    reg clk;
    reg rst_n;
    reg shift_en;
    reg rw_en;
    reg [7:0] parallel_in;
    reg sda_in;
    reg en_w;

    wire [7:0] parallel_out;
    wire sda_out;

    // DUT instantiation
    shift_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .rw_en(rw_en),
        .parallel_in(parallel_in),
        .sda_in(sda_in),
        .en_w(en_w),
        .parallel_out(parallel_out),
        .sda_out(sda_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Testbench stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        shift_en = 0;
        rw_en = 0;
        parallel_in = 8'h00;
        sda_in = 0;
        en_w = 0;

        // Reset the design
        #20 rst_n = 1;
        
        // Test write operation
        en_w = 1; // Enable write mode
        parallel_in = 8'b10101011; // Load input data
        shift_en = 1; // Enable shifting
        rw_en = 0; // Write mode
		#10;
      	en_w = 0;

        // Observe serial output for writing
      repeat(8) #10;

        // Test read operation
        en_w = 0; // Disable write
        rw_en = 1; // Read mode
        sda_in = 1; // Serial data input
        #10;
		sda_in =0;
      	#10;
		sda_in =1;
      	#10;
		sda_in =0;
      	#10;
		sda_in =1;
      	#10;
		sda_in =0;
      	#10;
		sda_in =1;
      	#10;
		sda_in =1;
      	#10;
        shift_en = 0;

        // Observe parallel output for reading
        #200;

        // End simulation
        $stop;
    end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
endmodule
