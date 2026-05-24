`timescale 1ns / 1ps

module tb_calculator();

    reg clk;
    reg reset;
    reg mode_select;
    reg [3:0] opcode;
    
    // Inputs must be signed in the testbench too!
    reg signed [15:0] operand_A;
    reg signed [15:0] operand_B;
    
    // Math result is signed, Converter results are standard wires
    wire signed [31:0] math_result;
    wire [31:0] out_decimal;
    wire [31:0] out_octal;
    wire [15:0] out_hex;
    wire [15:0] out_binary;

    top_calculator uut (
        .clk(clk),
        .reset(reset),
        .mode_select(mode_select),
        .opcode(opcode),
        .operand_A(operand_A),
        .operand_B(operand_B),
        .math_result(math_result),
        .out_decimal(out_decimal),
        .out_octal(out_octal),
        .out_hex(out_hex),
        .out_binary(out_binary)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; mode_select = 0; opcode = 0; 
        operand_A = 16'd0; operand_B = 16'd0;
        #20 reset = 0; 
    end

endmodule