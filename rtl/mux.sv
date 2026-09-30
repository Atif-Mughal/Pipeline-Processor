`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 09:12:38 PM
// Design Name: 
// Module Name: mux
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


module mux(
    input logic [31:0] a, b, c, d,  // 32-bit inputs to the multiplexer
    input logic [2:0] sel,          // 3-bit select signal to choose one of the inputs
    output logic [31:0] out         // 32-bit output based on the selected input
);
    always_comb begin
        // Multiplexer behavior using case statement
        // The output is assigned based on the value of the select signal (sel)
        casex(sel)
            3'b000: out = a;        // If sel is 000, choose input 'a'
            3'b0x1: out = b;        // If sel is 001 or 011, choose input 'b'
            3'b010: out = c;        // If sel is 010, choose input 'c'
            3'b11x: out = d;        // If sel is 110 or 111, choose input 'd'
            default: out = 0;       // Default case, set output to 0 if no conditions match
        endcase
    end
endmodule
