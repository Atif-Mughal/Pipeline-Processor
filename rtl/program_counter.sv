`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 01:37:38 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter #(parameter PC_WIDTH = 32) (
    input logic clk,                          // Clock signal (active on positive edge)
    input logic reset,                        // Reset signal (active high, synchronous)
    input logic [PC_WIDTH - 1 : 0] PC_in,     // New Program Counter (PC) value to be loaded
    output logic [PC_WIDTH - 1: 0] PC_out     // Current Program Counter (PC) value
);

    // Sequential logic block, triggered on the positive edge of the clock
    always_ff @(posedge clk) begin
        // If reset is asserted, reset the PC to 0
        if (reset) begin
            PC_out <= 32'h80000000;                      // Set the PC to 0 on reset
        end
        // Otherwise, update the PC with the next instruction address (PC_in)
        else begin
            PC_out <= PC_in;                  // Normal operation, update PC_out with PC_in
        end
    end
endmodule
