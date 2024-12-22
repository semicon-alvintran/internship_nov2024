`timescale 1ns / 1ps



module Branch(
    input [31:0] dataA,         // First input operand
    input [31:0] dataB,         // Second input operand
    input brUn,                 // Unsigned comparison mode (1 = unsigned, 0 = signed)
    output brEq,                // Branch Equal output (1 if dataA == dataB)
    output brLt  
    );
    
    wire signed [31:0] signedA = dataA;  // Signed version of dataA
    wire signed [31:0] signedB = dataB;  // Signed version of dataB

    wire brEq_t;                         // Temporary equality result
    wire brLt_signed_t;                  // Temporary signed less-than result
    wire brLt_unsigned_t;                // Temporary unsigned less-than result

    // Equality check
    assign brEq_t = (dataA == dataB);

    // Less-than comparisons
    assign brLt_signed_t = (signedA < signedB);    // Signed comparison
    assign brLt_unsigned_t = (dataA < dataB);      // Unsigned comparison

    // MUX for selecting signed or unsigned less-than
    assign brLt = brUn ? brLt_unsigned_t : brLt_signed_t;
    assign brEq = brEq_t;

endmodule
