`timescale 1ns / 1ps

module top_calculator (
    input clk,
    input reset,
    input mode_select,         // 0 = Normal Math, 1 = Base Converter
    input [3:0] opcode,        // Math Opcodes
    
    // --- The SIGNED Inputs ---
    input signed [15:0] operand_A,    
    input signed [15:0] operand_B,
    
    // --- MODE 0 OUTPUT ---
    output reg signed [31:0] math_result,
    
    // --- MODE 1 OUTPUTS ---
    output reg [31:0] out_decimal,
    output reg [31:0] out_octal,
    output reg [15:0] out_hex,
    output reg [15:0] out_binary
);

    // Hardware Edge-Case Protection:
    // If a user leaves a negative number in A and switches to Converter mode,
    // this instantly turns it positive so the slicing math doesn't break!
    wire [15:0] abs_A = (operand_A[15]) ? -operand_A : operand_A;

    always @(posedge clk) begin
        if (reset) begin
            math_result <= 32'd0;
            out_decimal <= 32'd0;
            out_octal   <= 32'd0;
            out_hex     <= 16'd0;
            out_binary  <= 16'd0;
        end else begin
            
            // --- MODE 0: Normal Calculator (SIGNED MATH) ---
            if (mode_select == 1'b0) begin
                case (opcode)
                    4'b0000: math_result <= operand_A + operand_B; // ADD
                    4'b0001: math_result <= operand_A - operand_B; // SUB
                    4'b0010: math_result <= operand_A * operand_B; // MULT
                    4'b0011: math_result <= (operand_B != 0) ? (operand_A / operand_B) : 32'd0; // DIV
                    default: math_result <= 32'd0;
                endcase
                
                out_decimal <= 32'd0;
                out_octal   <= 32'd0;
                out_hex     <= 16'd0;
                out_binary  <= 16'd0;
            end 
            
            // --- MODE 1: Number System Converter ---
            else begin
                math_result <= 32'd0;
                
                // We use 'abs_A' here so negative numbers don't break the BCD math
                out_decimal[3:0]   <= abs_A % 10;
                out_decimal[7:4]   <= (abs_A / 10) % 10;
                out_decimal[11:8]  <= (abs_A / 100) % 10;
                out_decimal[15:12] <= (abs_A / 1000) % 10;
                out_decimal[19:16] <= (abs_A / 10000) % 10;
                out_decimal[31:20] <= 0;
                
                out_octal[3:0]   <= abs_A % 8;
                out_octal[7:4]   <= (abs_A / 8) % 8;
                out_octal[11:8]  <= (abs_A / 64) % 8;
                out_octal[15:12] <= (abs_A / 512) % 8;
                out_octal[19:16] <= (abs_A / 4096) % 8;
                out_octal[23:20] <= (abs_A / 32768) % 8;
                out_octal[31:24] <= 0;
                
                // Hex and Binary display the raw Two's Complement bits (including the negative data!)
                out_hex    <= operand_A;
                out_binary <= operand_A;
            end
            
        end
    end

endmodule