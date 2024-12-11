`timescale 1ns / 1ps

module tb_FSM_i2c_master;

    // Testbench signals
    logic clk;
    logic reset_n;
    logic start;
    logic [6:0] address;
    logic rw;
    logic [7:0] idata;
    logic ACK_ADDR;

	logic sda_in;  
    logic shift_en;
    logic [7:0] odata;
    tri i2c_sda; // SDA bus (bidirectional)
    logic i2c_scl;

    // Instantiate DUT
    FSM_i2c_master dut (
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .address(address),
        .rw(rw),
        .idata(idata),
        .ACK_ADDR(ACK_ADDR),
        .sda_in(sda_in),
        .shift_en(shift_en),
        .odata(odata),
        .i2c_sda(i2c_sda),
      .i2c_scl(i2c_scl)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period (100MHz)

    // Test sequence
    initial begin
        // Initialize signals
        reset_n = 0;
        start = 0;
        address = 7'b1010101; // Example address
        rw = 0;               // Write operation
        idata = 8'h55;        // Example data
        ACK_ADDR = 0;
        sda_in = 0;       // Example data to simulate read

        // Apply reset
        #20 reset_n = 1;

        // Start condition for write
        $display("Starting I2C Write transaction...");
        #10 start = 1;
        #10 start = 0;

        // Wait for SDA to go low for START condition
        wait (i2c_sda === 1'b0);
        $display("START condition detected for write.");

        // Simulate ACK for address
        #50 ACK_ADDR = 1;
        $display("ACK received for address (Write).");

        // Wait for data transfer to complete
        #100;
        $display("Write transaction complete.");

      

        // Start condition for read
        $display("Starting I2C Read transaction...");
        #50;
        rw = 1; // Set to read mode
        #10 start = 1;
        #10 start = 0;

        // Wait for SDA to go low for START condition
        wait (i2c_sda === 1'b0);
        $display("START condition detected for read.");
      	
        // Simulate ACK for address
        #50 ACK_ADDR = 1;
        $display("ACK received for address (Read).");
		#50;
      repeat(8) begin
        sda_in = ~sda_in;
        #10;
      end
        // Wait for data transfer to complete
        #100;
        $display("Read transaction complete.");

        // Verify read outputs
        $display("Verifying Read outputs...");
        if (odata === sda_in) begin
            $display("Read Test Passed: odata = %h", odata);
        end else begin
            $display("Read Test Failed: odata = %h (expected %h)", odata, sda_in);
        end

        // End of test
        #300;
        $stop;
    end

    // Dump simulation waveforms
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
    end
endmodule
