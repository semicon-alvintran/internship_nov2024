module clock_divide(
	input logic clk,
   input logic rst_n,
  	input logic [6:0] address,
  	input logic [7:0] writedata,
	output logic [9:0] stretch,
  	output logic clk_out
);
  localparam logic [2:0] CLK_400KHZ = 3'd4;
  localparam logic [1:0] CLK_100KHZ = 1'd1;
  logic state;
  logic [9:0] count;
  logic [9:0] counter;
  logic [9:0] clk_in; 
  assign clk_in = {writedata,2'b0};
  assign stretch = (count<<1) + 2;
  always@(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      count <=  8'b0;
      state <= 2'b0;
    end else begin
      case(address)
        7'd0: begin 
          state <= 1'b1;
          count <= ((clk_in/CLK_400KHZ)/2)-1;
        end
        7'd1: begin 
          state <= 1'b1;
          count <= ((clk_in/CLK_100KHZ)/2)-1;
        end
        7'd2: begin
          state <= 1'b0;
        end
      endcase
    end
  end
  
  always@(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
    	clk_out <= 0;
      	counter <= 0;
    end else if(state) begin
      if (counter == count) begin
               counter <= 0;
               clk_out <= ~clk_out;
        end else begin
               counter <= counter + 1;
        end
    end else begin
      	clk_out <= clk;
    end
  end
  
  
endmodule
