module tb_FSM_i2c_slave;
    // Inputs
    logic reset_n;
    logic i2c_sda;
    logic i2c_scl;

    // Outputs
    logic valid_address;
    logic sda_out;

    // Internal signals
    logic [6:0] master_address = 7'b1010100; // Slave's expected address
    logic [7:0] master_data = 8'b11001100;   // Data to write to the slave
    logic rw_bit;                           // Read/Write bit

    // Instantiate the DUT
    FSM_i2c_slave dut (
        .reset_n(reset_n),
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl),
        .valid_address(valid_address),
        .sda_out(sda_out)
    );

    // Clock generation for I2C SCL
    initial begin
        i2c_scl = 0;
        forever #5 i2c_scl = ~i2c_scl; // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Reset the DUT
        reset_n = 0;
        i2c_sda = 1; // Idle state for SDA
        #20 reset_n = 1;

        // START condition
        @(posedge i2c_scl); 
        i2c_sda = 0; // SDA goes low while SCL is high

        // Send 7-bit slave address
        #10;
        for (int i = 6; i >= 0; i--) begin
            @(posedge i2c_scl);
            i2c_sda = master_address[i];
        end

        // Send R/W bit (write operation)
        @(posedge i2c_scl);
        rw_bit = 0; // Write operation
        i2c_sda = rw_bit;

        // Wait for ACK (from slave)
        @(posedge i2c_scl);
        i2c_sda = 1; // Release SDA, slave should ACK with 0
        #10;

        // Write 8-bit data to slave
      for (int i = 7; i >= 0; i--) begin
            
            i2c_sda = master_data[i];
        @(posedge i2c_scl);
        end
		i2c_scl = 1;
        // Wait for slave to finish
        #10;
        i2c_sda = 1; // Release SDA line
		
        // Add delay and finish simulation
        #100;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor($time, " Reset: %b | SCL: %b | SDA: %b | Valid Address: %b | SDA Out: %b | State: %s",
                 reset_n, i2c_scl, i2c_sda, valid_address, sda_out, dut.state.name());
    end
	initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
    end
endmodule
