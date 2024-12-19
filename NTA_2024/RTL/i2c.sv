module i2c(
	input logic clk_ex,
	input logic rst_n,
	input logic [6:0] address,
	input logic [7:0] writedata,
	input logic cs,
	input logic rd,
	input logic wr,
	
	output logic stop,
	output logic [7:0] readata
);

		logic clk_inter;
		logic rw;
		logic start;
		logic [7:0] writedataout;
		logic [6:0] addressout;
		logic [9:0] stretch;
		logic valid_address;
		logic sda_out;
		logic hold;
		
		logic i2c_sda;
		logic i2c_scl;
		
	clock_divide clkgen(
		.clk(clk_ex),
		.rst_n(rst_n),
		.address(address),
		.writedata(writedata),
		.clk_out(clk_inter),
		.stretch(stretch)
	);
	
	start_gen genstart(
        .clk(clk_inter),
        .clk_ex(clk_ex),
        .cs(cs),
        .wr(wr),
        .rd(rd),
        .rst_n(rst_n),
        .stretch(stretch),
		  .start(start),
        .rw(rw),
        .writedatain(writedata),
        .writedataout(writedataout),
		  .addressin(address),
        .addressout(addressout),
        .hold(hold),
        .stop(stop)
    );
	 
	 FSM_i2c_master fsmmaster(
		.clk(clk_inter),
		.reset_n(rst_n),
		.start(start),
		.address(addressout),
		.rw(rw),
		.idata(writedataout),
		.ACK_ADDR(valid_address),
		.sda_in(sda_out),
		.hold(hold),
		.odata(readata),
		.i2c_sda(i2c_sda),
		.i2c_scl(i2c_scl)
	 );
	 
	 FSM_i2c_slave fsmslave(
        .reset_n(rst_n),
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl),
        .valid_address(valid_address),
        .sda_out(sda_out)
    );

endmodule