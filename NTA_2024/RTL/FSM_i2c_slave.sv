module FSM_i2c_slave(
    input  logic reset_n,
    input  logic i2c_sda,    // Data line (from master to slave)
    input  logic i2c_scl,    // Clock line
    output logic valid_address, // Indicates when address matches
    output logic sda_out      // Slave data output (to master's SDA input)
);

    typedef enum logic [2:0] {
        IDLE,       // Wait for START condition
        ADDR,       // Address phase
        RW,         // Read/Write phase
        DATA_WRITE, // Write data to slave
        DATA_READ   // Read data from slave
    } state_t;

    state_t state;
    localparam logic [6:0] slave_address = 7'b1010100;  // Slave's own address
    logic [6:0] addr_buffer;    // Buffer for received address
    logic rw_bit;               // R/W bit from master
    logic [7:0] data_reg;       // Register to store slave data
    logic [7:0] data_buffer;    // Buffer for read/write data
    logic [3:0] bit_count;      // Bit counter

    assign valid_address = (state == RW) && (addr_buffer == slave_address);
	assign data_reg = data_buffer;
  always @(posedge i2c_scl or negedge reset_n) begin
        if (~reset_n) begin
            state <= IDLE;
            addr_buffer <= 7'b0;
            rw_bit <= 1'b0;
            bit_count <= 4'd0;
            sda_out <= 1'b1;
        end else begin
            case (state)
                // Wait for START condition
                IDLE: begin
                    if (i2c_sda == 0 && i2c_scl == 1) begin // Detect START
                        state <= ADDR;
                        bit_count <= 6; // 7-bit address
                    end
                end

                // Receive 7-bit address
                ADDR: begin
                    addr_buffer[bit_count] <= i2c_sda;
                    if (bit_count == 0) begin
                        state <= RW;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end

                // Receive R/W bit
                RW: begin
                    rw_bit <= i2c_sda;
                    if (addr_buffer == slave_address) begin
                        sda_out <= 0; // Acknowledge address match
                        state <= (rw_bit) ? DATA_READ : DATA_WRITE; // Determine next state
                        bit_count <= 7; // Prepare for 8-bit data
                    end else begin
                        state <= IDLE; // Ignore if address doesn't match
                    end
                end

                // Write data to slave
                DATA_WRITE: begin
                    data_buffer[bit_count] <= i2c_sda; // Capture data from SDA
                    if (bit_count == 0) begin
                        state <= IDLE; // Return to IDLE
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end

                // Read data from slave
                DATA_READ: begin
                    sda_out <= data_reg[bit_count]; // Provide data to SDA
                    if (bit_count == 0) begin
                        state <= IDLE; // Return to IDLE
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule

