module FSM_i2c_master(
    input logic clk,
    input logic reset_n,
    input logic start,
    input logic [6:0] address,
    input logic rw,
    input logic [7:0] idata,
    input logic ACK_ADDR,
    input logic sda_in,
    
    output logic shift_en,
    output logic [7:0] odata,
    output  logic i2c_sda, 
    output logic i2c_scl
);
    typedef enum logic [2:0] {
        IDLE,       // Wait
        START,      // START
        ADDR,       // Address // Read or Write (Write = 0, Read = 1)
        RW,
        ACKADDR,    // ACK for address
        DATA,       // DATA
        ACKDATA,    // ACK/NACK
        STOP        // STOP
    } state_t;
  
    state_t state;
    logic [3:0] count;
    logic i2c_scl_en;
    logic [7:0] reg_out;
  
    assign odata = reg_out;
    assign i2c_scl = (i2c_scl_en == 0) ? 1 : clk;


   
  
  always @(negedge clk or negedge reset_n) begin
        if (~reset_n) begin
            i2c_scl_en <= 1'b0;
        end else begin
            if ((state == IDLE) || (state == START) || (state == STOP)) begin
                i2c_scl_en <= 1'b0;
            end else begin
                i2c_scl_en <= 1'b1;
            end
        end 
    end
  
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= IDLE;
            shift_en  <= 0;
            count <= 4'b0;
            i2c_sda <= 1'b1;
        end else begin 
            case (state)
                // state IDLE
                IDLE: begin
                    i2c_sda <= 1'b1;
                    shift_en <= 1'b0;
                    if (start) begin
                        state <= START; 
                    end else begin
                        state <= IDLE; 
                    end
                end

                // state START
                START: begin
                    i2c_sda <= 1'b0;
                    state <= ADDR;
                    count <= 6;
                end

                // state ADDR
                ADDR: begin
                    i2c_sda <= address[count];
                    if (count == 0) begin 
                        state <= RW; 
                    end else begin 
                        count <= count - 1; 
                    end
                end

                // RW
                RW: begin
                    i2c_sda <= rw;
                    state <= ACKADDR;
                end

                // state ACKADDR
                ACKADDR: begin
                    if (ACK_ADDR) begin
                        i2c_sda <= 1'b1;
                        state <= DATA;
                        count <= 4'd7;
                    end else if (i2c_sda == 0) begin
                        state <= ACKADDR;
                    end else begin
                        state <= STOP;
                    end
                end

                // state DATA
                DATA: begin
                    if (~rw) begin
                        i2c_sda <= idata[count];
                    end else begin
                      	i2c_sda <= sda_in;
                      	reg_out[count] <= sda_in;
                    end

                    if (count == 0) begin 
                        state <= ACKDATA; 
                    end else begin 
                        count <= count - 1; 
                    end
                end

                // state ACKDATA
                ACKDATA: begin
                    i2c_sda <= 1'b1;
                    state <= STOP;
                end

                // state STOP
                STOP: begin
                    i2c_sda <= 1'b0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
