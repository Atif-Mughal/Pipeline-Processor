`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:35:26 PM
// Design Name: 
// Module Name: mux_2x1
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


module mux_2x1(
    input logic [31:0] a, b,   // 32-bit input signals (a, b)
    input logic sel,           // 1-bit select signal (sel) to choose one of the inputs
    output logic [31:0] y      // 32-bit output (y) based on the selected input
    );
    
    // Combinational always block to determine the output based on the select signal
    always_comb begin
        // Case statement to select one of the inputs (a or b) based on 'sel'
        case (sel)
            1'b0: y = a;    // When sel is 0, select input 'a'
            1'b1: y = b;    // When sel is 1, select input 'b'
            default: y = 1'b0;  // Default case: set output to 0 if sel is invalid (shouldn't happen with a 1-bit select)
        endcase
    end
endmodule

