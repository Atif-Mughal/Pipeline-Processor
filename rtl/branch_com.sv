`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2024 01:33:38 AM
// Design Name: 
// Module Name: branch_com
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//    This module compares two 32-bit inputs (A and B) based on a branch 
//    condition specified by the BrUn signal. It outputs two signals: 
//    Eq (indicating equality) and Lt (indicating whether A is less than B).
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module branch_com(
    input [31:0] A,       // First 32-bit input for comparison
    input [31:0] B,       // Second 32-bit input for comparison
    input BrUn,           // Branch unsigned condition signal
    output logic Eq,      // Output logic indicating if A is equal to B
    output logic Lt       // Output logic indicating if A is less than B
    );

    // Combinational always block to perform the comparisons
    always_comb begin
        if (BrUn) begin
            // When BrUn is high, treat A and B as unsigned integers
            if (A == B) begin
                Eq = 1'b1;     // A is equal to B
                Lt = 1'b0;     // A is not less than B
            end
            else if ($unsigned(A) < $unsigned(B)) begin
                Eq = 1'b0;     // A is not equal to B
                Lt = 1'b1;     // A is less than B
            end
            else begin
                Eq = 1'b0;     // A is not equal to B
                Lt = 1'b0;     // A is not less than B
            end
        end
        else begin
            // When BrUn is low, treat A and B as signed integers
            if (A == B) begin
                Eq = 1'b1;     // A is equal to B
                Lt = 1'b0;     // A is not less than B
            end
            else if (A < B) begin
                Eq = 1'b0;     // A is not equal to B
                Lt = 1'b1;     // A is less than B
            end
            else begin
                Eq = 1'b0;     // A is not equal to B
                Lt = 1'b0;     // A is not less than B
            end
        end
    end
endmodule
