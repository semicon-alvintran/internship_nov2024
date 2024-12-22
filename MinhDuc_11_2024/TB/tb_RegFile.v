`timescale 1ns / 1ps



module tb_RegFile;
    reg clk;
    reg rst;
    reg RegW;
    reg [4:0] Rs1, Rs2, Rd;
    reg [31:0] Wd;
    wire [31:0] rd1, rd2;
    
    RegFile uut(
        .clk(clk),
        .rst(rst),
        .RegW(RegW),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(Rd),
        .Wd(Wd),
        .rd1(rd1),
        .rd2(rd2)
    );
    //Create clk signal
    always begin
        #5 clk = ~clk;  //10ns
    end
    
     initial begin
        
        clk = 0;
        rst = 0;
        RegW = 0;
        Rs1 = 5'b00000;
        Rs2 = 5'b00001;
        Rd = 5'b00000;
        Wd = 32'h0;

        //reset  kiem tra
        $display("Test case 1: Reset");
        rst = 1;
        #10;
        rst = 0;

        //kiem tra viec ghi vao thanh ghi
        $display("Test case 2: Write to register 5");
        Rs1 = 5'b00001; Rs2 = 5'b00010; Rd = 5'b00101;
        Wd = 32'h12345678;
        RegW = 1; //kich hoat thanh ghi
        #10;
        RegW = 0; //tat thanh ghi

        // kiem tra doc du lieu thanh ghi
        $display("Test case 3: Read from register 5");
        Rs1 = 5'b00000; Rs2 = 5'b00001; //doc thanh ghi 0 va 1
        #10;
        
        //kiem tra ghi vao thanh ghi 31
        $display("Test case 4: Write to register 31");
        Rs1 = 5'b00001; Rs2 = 5'b00010; Rd = 5'b11111;
        Wd = 32'hAABBCCDD;
        RegW = 1;
        #10;
        RegW = 0;

        //Doc lai cac thanh ghi
        $display("Test case 5: Read from register 31");
        Rs1 = 5'b11111; Rs2 = 5'b00001;
        #10;

        //kiem tra 0 ghi vao thanh ghi 0
        $display("Test case 6: Attempt to write to register 0 (x0)");
        Rs1 = 5'b00001; Rs2 = 5'b00010; Rd = 5'b00000; 
        Wd = 32'hDEADBEEF;
        RegW = 1;
        #10;
        RegW = 0;

       // kiem tra ket qua cuoi cung
        $display("Test case 7: Final check");
        Rs1 = 5'b11111; Rs2 = 5'b00001; //doc thanh ghi tu 31 va 1
        #10;

        $finish; 
    end

    
    initial begin
        $monitor("At time %t: rd1 = %h, rd2 = %h", $time, rd1, rd2);
    end
endmodule
