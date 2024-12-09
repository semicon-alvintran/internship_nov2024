// Code your design here
module shift_register (
    input logic clk,                   
    input logic rst_n,                 
    input logic shift_en,              
    input logic rw_en,                 
    input logic [7:0] parallel_in,     // Parallel data input (for writing)
    input logic sda_in,                // Serial input from SDA (for reading)
	 input logic en_w,
  
    output logic [7:0] parallel_out,   // Parallel data output (for reading)
    output logic sda_out               // Serial output to SDA (for writing)
);
    logic [7:0] shift_reg;
    logic [7:0] reg_write;
  
  	
	
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end
      else if(en_w) begin
        reg_write <= parallel_in;
      end
      else if (shift_en) begin	  		  
           if (~rw_en) begin
                // Write: shift out data
                reg_write <= {reg_write[6:0], 1'b0}; //LSB
            end else begin
                // Read: shift in data
              	shift_reg <= {shift_reg[6:0], sda_in};// MSB
            end
        end
    end

    // Outputs
    assign parallel_out = shift_reg; 
    assign sda_out = reg_write[7];
endmodule