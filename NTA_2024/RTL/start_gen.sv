module start_gen (
    input logic clk,       // FSM clock (slower)
    input logic clk_ex,    // External clock (faster)
    input logic cs,        // Chip select
    input logic wr,        // Write signal
    input logic rd,        // Read signal
    input logic rst_n,     // Reset signal (active low)
	 input logic [9:0] stretch,
  	 input logic [7:0] writedatain,
  	 input logic [6:0] addressin,
  	 input logic hold, // hold to wait read
  
    output logic stop,// stop = 1 if read not done , stop = 0 read done
  	 output logic [7:0] writedataout,
  	 output logic [6:0] addressout,
    output logic start,     // Start signal for FSM (in clk domain)
  	 output logic rw
);

    // Pulse generation in clk_ex domain
    logic cs_sync_ex, wr_sync_ex, rd_sync_ex;
    logic start_ex;  // Start signal in clk_ex domain
    logic start_stretched; // Stretched pulse in clk_ex domain
  	logic read_hold;
  	logic [7:0] writestore;
  	logic [6:0] addressstore;
    // Synchronization to clk_ex domain
    always @(posedge clk_ex or negedge rst_n) begin
        if (~rst_n) begin
            cs_sync_ex <= 1'b0;
            wr_sync_ex <= 1'b0;
            rd_sync_ex <= 1'b0;
        end else begin
            cs_sync_ex <= cs;
            wr_sync_ex <= wr;
            rd_sync_ex <= rd;
        end
    end

    // Generate start signal in clk_ex domain
    always @(posedge clk_ex or negedge rst_n) begin
        if (~rst_n) begin
            start_ex <= 1'b0;
        end else begin
            start_ex <= cs_sync_ex && (wr_sync_ex || rd_sync_ex);
        end
    end

    // Stretch the start_ex pulse in clk_ex domain
  	logic [9:0] stretch_counter; // Stretch duration
    always @(posedge clk_ex or negedge rst_n) begin
        if (~rst_n) begin
            start_stretched <= 1'b0;
            stretch_counter <= 2'b0;
          	read_hold <= 1'b0;
				writestore <= 8'b0;
				addressstore <= 7'b0;
        end else if (start_ex) begin
            start_stretched <= 1'b1;
            stretch_counter <= stretch;
				writestore <= writedatain;
            addressstore <= addressin;
          if(rd) begin
            read_hold <= 1'b1;
          end else if(wr) begin
          	read_hold <= 1'b0;
          end
        end else if (stretch_counter != 0) begin
            stretch_counter <= stretch_counter - 1;
        end else begin
            start_stretched <= 1'b0;
        end
    end

    // Synchronize the stretched start signal to clk domain
    logic start_sync_1, start_sync_2;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            start_sync_1 <= 1'b0;
            start_sync_2 <= 1'b0;
        end else begin
            start_sync_1 <= start_stretched;  // First synchronization flop
            start_sync_2 <= start_sync_1;    // Second synchronization flop
        end
    end
	
  	always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            stop <= 1'b0;
        end else if(hold) begin
            stop <= 1'b1;
        end else begin
          	stop <= 1'b0;
        end
    end
  
    // Generate the final start pulse in clk domain
  assign start = start_sync_1 && (start_sync_2==0);
  assign rw = read_hold;
  assign writedataout = writestore;
  assign addressout = addressstore;
endmodule
