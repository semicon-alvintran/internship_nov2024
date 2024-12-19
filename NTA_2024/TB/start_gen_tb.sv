// Testbench for start_gen
module tb_start_gen();

    logic clk;
    logic clk_ex;
    logic cs;
    logic wr;
    logic rd;
    logic rst_n;
    logic [9:0] stretch;
    logic start;
	logic rw;
  	logic [7:0] writedatain;
  	logic [7:0] writedataout;
  	logic [6:0] addressin;
  	logic [6:0] addressout;
  	logic hold;
  	logic stop;
    // Instantiate the DUT (Device Under Test)
    start_gen uut (
        .clk(clk),
        .clk_ex(clk_ex),
        .cs(cs),
        .wr(wr),
        .rd(rd),
        .rst_n(rst_n),
        .stretch(stretch),
      	.start(start),
      	.rw(rw),
      	.writedatain(writedatain),
      	.writedataout(writedataout),
      	.addressin(addressin),
      	.addressout(addressout),
      	.hold(hold),
      	.stop(stop)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 10 MHz clock (100 ns period)
    end

    initial begin
        clk_ex = 0;
        forever #5 clk_ex = ~clk_ex; // 100 MHz clock (20 ns period)
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;
        cs = 0;
        wr = 0;
        rd = 0;
        stretch = 10'd100; // Stretch duration (arbitrary for this test)
      	writedatain = 8'd20;
		addressin = 7'b1010001;
        // Release reset
        #100 rst_n = 1;

        // Test case 1: Generate start signal with wr
        #100;
        cs = 1;
        wr = 1;
        #40;
        cs = 0;
        wr = 0;

        // Wait and observe start signal in clk domain
        #1205;

        // Test case 2: Generate start signal with rd
        cs = 1;
        rd = 1;
      	hold = 1;
        #40;
        cs = 0;
        rd = 0;
      	#400;
		hold = 0;
        // Wait and observe start signal in clk domain
        #500;

        // Test case 3: Reset during operation
        cs = 1;
        wr = 1;
        #20;
        rst_n = 0;
        #50;
        rst_n = 1;
        cs = 0;
        wr = 0;

        // Wait and observe behavior after reset
        #500;

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " clk=%b clk_ex=%b cs=%b wr=%b rd=%b start=%b", clk, clk_ex, cs, wr, rd, start);
    end
	 initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
