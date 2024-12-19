module FSM_i2c_master(
    input logic clk,
    input logic reset_n,
    input logic start,
    input logic [6:0] address,
    input logic rw,
    input logic [7:0] idata,
    input logic ACK_ADDR,
    input logic sda_in,
    
	 output logic m_stop,
    output logic hold,
    output logic [7:0] odata,
    output logic i2c_sda, 
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
	 logic [6:0] address_store;
	 logic [7:0] reg_in;
    
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
            reg_in <= 8'b0;
				address_store <= 7'b0;
        end else begin
           if(start && (rw==0)) begin
					 reg_in <= idata;
					 address_store <= address;
			  end else begin
					 address_store <= address;
			  end
		  end
    end
	 
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= IDLE;
				hold <= 1'b0;
            count <= 4'b0;
            i2c_sda <= 1'b1;
				m_stop <= 1'b1;
        end else begin 
            case (state)
                // state IDLE
                IDLE: begin
                    i2c_sda <= 1'b1;
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
						  m_stop <= 1'b0;
                end

                // state ADDR
                ADDR: begin
                    i2c_sda <= address_store[count];
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
                    end else if (sda_in == 1) begin
                        state <= ACKADDR;
                    end else begin
                        state <= STOP;
								m_stop <= 1;
                    end
						  
						  if(~rw) begin
								count <= 4'd7;
						  end else begin
								count <= 4'd9;
						  end
                end

                // state DATA
                DATA: begin
                    if (~rw) begin
                        i2c_sda <= reg_in[count];
                    end else begin
                      	i2c_sda <= sda_in;
                      	reg_out[count] <= sda_in;
								hold <= 1'b1;
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
						  hold <= 1'b0;
                    state <= IDLE;
						  m_stop <= 1;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
