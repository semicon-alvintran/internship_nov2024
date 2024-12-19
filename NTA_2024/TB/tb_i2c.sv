 `timescale 1ns / 1ps

module tb_i2c;

    // Testbench signals
    logic clk_ex;
    logic rst_n;
    logic [6:0] address;
    logic [7:0] writedata;
    logic cs;
    logic rd;
    logic wr;
    logic stop;
    logic [7:0] readata;

    // Internal bidirectional signals for I2C
    logic i2c_sda;
    logic i2c_scl;

    // Instantiate DUT
    i2c dut (
        .clk_ex(clk_ex),
        .rst_n(rst_n),
        .address(address),
        .writedata(writedata),
        .cs(cs),
        .rd(rd),
        .wr(wr),
        .stop(stop),
        .readata(readata)
    );

    // Clock generation
    initial clk_ex = 0;
    always #5 clk_ex = ~clk_ex; // 10ns period (100MHz)

    // Test sequence
    initial begin
        // Initialize signals for clk internal
        rst_n = 0;
        cs = 0;
        rd = 0;
        wr = 0;
        address = 7'b0000000;  // Match the slave address
        writedata = 8'd250; // 100MHz/400KHz

        // Apply reset
        #20 rst_n = 1;
		  
		  #100;
        // Write operation
        $display("Starting I2C Write operation...");
        cs = 1;
        wr = 1;
        #20 wr = 0;
		  cs = 0;

        // Wait for stop condition
        #100;
		  address = 7'b1010100;  // Match the slave address
        writedata = 8'b10110011; // 100MHz/400KHz
        
        #150000;
        cs = 1;
        wr = 1;
        #20 wr = 0;
		  cs = 0;
		  
		  #250000;
		  cs = 1;
		  rd = 1;
		  #40 rd = 0;
		  cs = 0;
        // Wait for stop condition
        wait (stop === 1);
        $display("I2C Read operation completed.");

   
    end

    // Dump simulation waveforms
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
    end

endmodule
