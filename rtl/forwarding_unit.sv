`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 09:01:06 PM
// Design Name: Forwarding Unit
// Module Name: forwarding_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The forwarding unit detects data hazards during the instruction execution stage 
// and determines if operand forwarding is required. It checks if the destination 
// register of a previous instruction matches the source registers of the current 
// instruction and signals hazards (hazard_A, hazard_B) accordingly.
//
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module forwarding_unit(
    input [31:0] instruction3, // Input: Current instruction in the EX stage
    input [31:0] instruction4, // Input: Previous instruction in the MEM stage
    output logic hazard_A,     // Output: Hazard signal for source register A
    output logic hazard_B      // Output: Hazard signal for source register B
);

    // Internal signals
    logic [4:0] operand_a;  // Source register A from instruction3 (bits [19:15])
    logic [4:0] operand_b;  // Source register B from instruction3 (bits [24:20])
    logic [4:0] operand_d;  // Destination register from instruction4 (bits [11:7])
    logic wr_en;            // Write enable signal for the destination register

    // Determine if the previous instruction writes to a register
    // instruction4[5], instruction4[4], and instruction4[2] are used to check if the instruction writes to a register
    assign wr_en = (~(instruction4[5] & ~instruction4[4] & ~instruction4[2])) ? 1'b1 : 1'b0;

    // Extract source registers from the current instruction (instruction3)
    assign operand_a = instruction3[19:15]; // Source register A
    assign operand_b = instruction3[24:20]; // Source register B

    // Extract destination register from the previous instruction (instruction4)
    assign operand_d = instruction4[11:7];  // Destination register

    // Detect data hazard for operand A
    // Hazard occurs if the destination register of instruction4 matches the source register A of instruction3,
    // and if the previous instruction writes to the register, and the registers are not zero (x0).
    assign hazard_A = ((operand_d == operand_a) && (wr_en == 1'b1) && (operand_a != 0) && (operand_d != 0));

    // Detect data hazard for operand B
    // Same logic as hazard_A but for source register B
    assign hazard_B = ((operand_d == operand_b) && (wr_en == 1'b1) && (operand_b != 0) && (operand_d != 0));

endmodule
