module start_gen(
 input logic clk,
 input logic rst_n,
 input logic rd,
 input logic wr,
 input logic cs,
  
 output logic start,
 output logic rw
);
  logic pre_signal;
  logic signal;
  assign signal = ((cs && rd) | (cs && wr)) ? 1'b1 : 1'b0;
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			start <= 1'b0;
			pre_signal <= 1'b0;
		end else begin 
			start      <= signal && (pre_signal == 1'b0);
			pre_signal <= signal;
		end
	end
  assign rw = (rd) ? 1'b1 : 1'b0;
endmodule