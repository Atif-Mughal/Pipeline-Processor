`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 01:53:14 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input logic clk,             // Clock signal (active on the negative edge)
    input logic reset,           // Reset signal (active high, synchronous)
    input logic reg_wr,          // Write enable signal for the register file
    input logic [4:0] rs1,       // Source register 1 (5-bit address)
    input logic [4:0] rs2,       // Source register 2 (5-bit address)
    input logic [4:0] rsW,       // Write register (5-bit address)
    input logic [31:0] dataW,    // Data to be written into register 'rsW'
    output logic [31:0] data1,   // Data read from source register 1 (rs1)
    output logic [31:0] data2    // Data read from source register 2 (rs2)
);

    // Declare a 32-element register file, where each register is 32-bits wide
    logic [31:0] register[31:0];

    // Assign read data for register 1 (rs1)
    // If rs1 is 0 (which is always hardwired to 0 in RISC-V), return 0
    // Otherwise, return the value stored in register[rs1]
    assign data1 = rs1 ? register[rs1] : '0;

    // Assign read data for register 2 (rs2)
    // If rs2 is 0, return 0 (since register[0] is always 0 in RISC-V)
    // Otherwise, return the value stored in register[rs2]
    assign data2 = rs2 ? register[rs2] : '0;

    // Always block triggered on the negative edge of the clock or positive edge of reset
    always_ff @(negedge clk or posedge reset) begin
        // If reset is asserted, initialize all registers to 0
        if (reset) begin
            register = '{default : 'x}; // Set all elements of the register array to 0
            register[0] = 0;
        end
        // If reg_wr is high and rsW is non-zero, write dataW to register[rsW]
        else if ((|rsW) & reg_wr) begin
            register[rsW] <= dataW; // Write dataW to the register specified by rsW
        end
        // Always ensure that register[0] remains 0, as it is hardwired to 0 in RISC-V
        else begin
            register[0] <= 0; // Explicitly maintain register[0] as 0
        end
    end
endmodule

