`timescale 1ns / 1ps


module tb_branch;
    reg [31:0] dataA, dataB;    // Inputs
    reg brUn;                   // Unsigned comparison mode
    wire brEq;                  // Outputs
    wire brLt;
    
    Branch uut (
        .dataA(dataA),
        .dataB(dataB),
        .brUn(brUn),
        .brEq(brEq),
        .brLt(brLt)
    );
    
    initial begin
        $display("Starting Branch Testbench...");
        // Case 1: brEq test (equal values)
        dataA = 32'd10;
        dataB = 32'd10;
        brUn = 1'b0; // Signed mode
        #10;
        $display("Case 1: brEq=%b, brLt=%b (Expected: brEq=1, brLt=0)", brEq, brLt);

        // Case 2: brEq test (not equal values)
        dataA = 32'd10;
        dataB = 32'd20;
        brUn = 1'b0; // Signed mode
        #10;
        $display("Case 2: brEq=%b, brLt=%b (Expected: brEq=0, brLt=1)", brEq, brLt);

        // Case 3: brLt test (signed comparison, dataA < dataB)
        dataA = -10;
        dataB = 32'd5;
        brUn = 1'b0; // Signed mode
        #10;
        $display("Case 3: brEq=%b, brLt=%b (Expected: brEq=0, brLt=1)", brEq, brLt);

        // Case 4: brLt test (signed comparison, dataA > dataB)
        dataA = 32'd5;
        dataB = -10;
        brUn = 1'b0; // Signed mode
        #10;
        $display("Case 4: brEq=%b, brLt=%b (Expected: brEq=0, brLt=0)", brEq, brLt);

        // Case 5: brLt test (unsigned comparison, dataA < dataB)
        dataA = 32'd10;
        dataB = 32'd20;
        brUn = 1'b1; // Unsigned mode
        #10;
        $display("Case 5: brEq=%b, brLt=%b (Expected: brEq=0, brLt=1)", brEq, brLt);

        // Case 6: brLt test (unsigned comparison, dataA > dataB)
        dataA = 32'd20;
        dataB = 32'd10;
        brUn = 1'b1; // Unsigned mode
        #10;
        $display("Case 6: brEq=%b, brLt=%b (Expected: brEq=0, brLt=0)", brEq, brLt);

        $display("Testbench complete.");
        $finish;
    end

    
endmodule
