`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2024 07:37:39 PM
// Design Name: 
// Module Name: mux_4x1
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


module mux_4x1(
    input logic [31:0] a, b, c, d,   // 32-bit input signals (a, b, c, d)
    input logic [1:0] sel,           // 2-bit select signal (sel) to choose one of the inputs
    output logic [31:0] out          // 32-bit output (out) based on the selected input
    );
    
    // Combinational always block to determine the output based on the select signal
    always_comb begin
        // Case statement to select one of the inputs (a, b, c, or d) based on 'sel'
        case(sel)
            2'b00: out = a;  // When sel is 00, select input 'a'
            2'b01: out = b;  // When sel is 01, select input 'b'
            2'b10: out = c;  // When sel is 10, select input 'c'
            2'b11: out = d;  // When sel is 11, select input 'd'
            default : out  = 0;  // Default case: if no valid 'sel' value, set output to 0
        endcase
    end
endmodule

