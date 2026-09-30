`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2024 07:09:22 PM
// Design Name: 
// Module Name: dm_signal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//    This module generates a byte selection signal based on the input address 
//    and function code (funct3). The output byte_sel indicates which byte(s) 
//    should be selected for a given operation in data memory.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dm_signal(
    input logic [1:0] addr,      // 2-bit input address to specify the byte offset
    input logic [1:0] funct3,    // 2-bit function code to determine the type of access
    output logic [3:0] byte_sel   // 4-bit output to select specific byte(s) in memory
    );

    // Combinational always block to determine the byte selection based on funct3 and addr
    always_comb begin
        case (funct3)
            2'b00: begin
                // If funct3 is 00, select a single byte based on addr
                case(addr)
                    2'b00: byte_sel = 4'b0001; // Select byte 0
                    2'b01: byte_sel = 4'b0010; // Select byte 1
                    2'b10: byte_sel = 4'b0100; // Select byte 2
                    2'b11: byte_sel = 4'b1000; // Select byte 3
                endcase
            end
            2'b01: begin
                // If funct3 is 01, select two bytes based on addr
                casex(addr)
                    2'b0x: byte_sel = 4'b0011; // Select bytes 0 and 1
                    2'b1x: byte_sel = 4'b1100; // Select bytes 2 and 3
                endcase
            end
            2'b10: begin
                // If funct3 is 10, select all four bytes
                byte_sel = 4'b1111; // Select bytes 0, 1, 2, and 3
            end
            default: byte_sel = 4'b0000; // Default case: no bytes selected
        endcase
    end
endmodule
