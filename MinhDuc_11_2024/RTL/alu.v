`timescale 1ns / 1ps



module alu(
    input [31:0] op1,
    input [31:0] op2,
    input [3:0] alu_sel,
    output reg [31:0] alu_out,
    output zero,
    output reg carry,
    output reg overflow
);
    reg [31:0] add_result, logic_result, shift_result, cmp_result;
    reg add_carry, add_overflow;
    reg cmp_zero, cmp_lt;

    // Addition/Subtraction Logic
    wire [31:0] B_in = op2 ^ {32{alu_sel[0]}}; // XOR for subtraction
    wire [32:0] sum = {1'b0, op1} + {1'b0, B_in} + alu_sel[0];

    always @(*) begin
        add_result = sum[31:0];
        add_carry = sum[32];
        add_overflow = (op1[31] == B_in[31]) && (add_result[31] != op1[31]);
    end

    // Logic Operations
    always @(*) begin
        case (alu_sel[1:0])
            2'b00: logic_result = op1 & op2;
            2'b01: logic_result = op1 | op2;
            2'b10: logic_result = op1 ^ op2;
            default: logic_result = 32'd0;
        endcase
    end

    // Shifter Operations
    always @(*) begin
        case (alu_sel[1:0])
            2'b00: shift_result = op1 << op2[4:0];
            2'b01: shift_result = op1 >> op2[4:0];
            2'b10: shift_result = $signed(op1) >>> op2[4:0];
            default: shift_result = 32'd0;
        endcase
    end

    // Comparator Logic
    always @(*) begin
        cmp_lt = (alu_sel[0] == 1'b0) ? (op1 < op2) : ($signed(op1) < $signed(op2));
        cmp_zero = (op1 == op2);
        cmp_result = {31'd0, cmp_lt}; // Only 1-bit result for lt
    end

    // Mux to select final ALU result
    always @(*) begin
        case (alu_sel[3:2])
            2'b00: alu_out = add_result;
            2'b01: alu_out = logic_result;
            2'b10: alu_out = shift_result;
            2'b11: alu_out = cmp_result;
            default: alu_out = 32'd0;
        endcase
    end

    // Flags
    assign zero = (alu_out == 32'd0);
    always @(*) begin
        carry = (alu_sel[3:2] == 2'b00) ? add_carry : 1'b0;
        overflow = (alu_sel[3:2] == 2'b00) ? add_overflow : 1'b0;
    end

endmodule
