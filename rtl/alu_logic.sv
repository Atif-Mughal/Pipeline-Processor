`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:32:46 PM
// Design Name: 
// Module Name: alu_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_logic(
    input logic [31:0] a,    // First 32-bit operand
    input logic [31:0] b,    // Second 32-bit operand
    input logic [6:0] op,    // 7-bit operation code to select ALU operation
    output logic [31:0] o    // 32-bit output result
    );
    
    // Internal logic wires to hold results of different ALU operations
    logic [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;

    // ALU Operations
    assign w0 = a + b;                  // Addition
    assign w1 = a - b;                  // Subtraction
    assign w2 = a << (b[4:0]);          // Logical left shift (by the 5 least significant bits of b)
    assign w3 = ($signed(a) < $signed(b)); // Signed less-than comparison
    assign w4 = ($unsigned(a) < $unsigned(b)); // Unsigned less-than comparison
    assign w5 = a ^ b;                  // Bitwise XOR
    assign w6 = a >> (b[4:0]);          // Logical right shift (by the 5 least significant bits of b)
    assign w7 = $signed(a) >>> (b[4:0]); // Arithmetic right shift (by the 5 least significant bits of b)
    assign w8 = a | b;                  // Bitwise OR
    assign w9 = a & b;                  // Bitwise AND
    assign w10 = b;                     // Pass-through (b is the result)

    // Multiplexing the result of the selected ALU operation based on the operation code (op)
    // The operation result is determined by the 7-bit op code
    mux_16x1 m16(
        .a0(w0), .a1(w1), .a2(w2), .a3(w3), .a4(w4), 
        .a5(w5), .a6(w6), .a7(w7), .a8(w8), .a9(w9), 
        .a10(w10), 
        .s16(op), .y16(o)  // Select one of the results based on op and assign it to output o
    );

endmodule

