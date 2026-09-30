`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:33:37 PM
// Design Name: 
// Module Name: mux_16x1
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



module mux_16x1(
    input logic [6:0] s16,    // 7-bit select signal to choose one of the 16 inputs
    input logic [31:0] a0,    // Input 0
    input logic [31:0] a1,    // Input 1
    input logic [31:0] a2,    // Input 2
    input logic [31:0] a3,    // Input 3
    input logic [31:0] a4,    // Input 4
    input logic [31:0] a5,    // Input 5
    input logic [31:0] a6,    // Input 6
    input logic [31:0] a7,    // Input 7
    input logic [31:0] a8,    // Input 8
    input logic [31:0] a9,    // Input 9
    input logic [31:0] a10,   // Input 10
    output logic [31:0] y16   // Output selected based on the value of s16
    );
    
    // Always block for combinational logic to select one of the inputs based on s16
    always_comb begin
        // Use case expression to determine which input is selected
        casex (s16)
            7'b000xxxx:  y16 = a0;   // Load or other operations that map to a0
            7'b011xxxx:  y16 = a0;   // AUIPC operation, maps to a0
            7'b010000x:  y16 = a0;   // ADDI instruction, maps to a0
            7'b1100000:  y16 = a0;   // ADD operation, maps to a0
            7'b100xxxx:  y16 = a0;   // Store instructions, maps to a0
            7'b111xxxx:  y16 = a10;  // LUI operation, maps to a10
            7'b101xxxx:  y16 = a0;   // Jumps and branch instructions, map to a0
            7'b1100001:  y16 = a1;   // Specific case for a1 selection (e.g., SUB)
            7'bx100010:  y16 = a2;   // Specific case for a2 selection (e.g., Shift Left)
            7'bx10010x:  y16 = a3;   // Specific case for a3 selection (e.g., Signed comparison)
            7'bx10011x:  y16 = a4;   // Specific case for a4 selection (e.g., Unsigned comparison)
            7'bx10100x:  y16 = a5;   // Specific case for a5 selection (e.g., XOR)
            7'bx101011:  y16 = a7;   // Specific case for a7 selection (e.g., Arithmetic right shift)
            7'bx101010:  y16 = a6;   // Specific case for a6 selection (e.g., Logical right shift)
            7'bx10110x:  y16 = a8;   // Specific case for a8 selection (e.g., OR)
            7'bx10111x:  y16 = a9;   // Specific case for a9 selection (e.g., AND)
            default: y16 = 32'h0;    // Default case, output zero if no match
        endcase
    end
    
endmodule

