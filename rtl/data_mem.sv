`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2024 12:02:38 PM
// Design Name: Data Memory Module
// Module Name: data_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module implements a data memory with byte, half-word, and word access. 
// It supports zero-extension or sign-extension for byte and half-word loads, 
// and it allows selective write access based on the byte select signal.
// 
// Inputs:
// - addr: 32-bit memory address.
// - dataW: 32-bit data to be written into memory (if Mem_RW is high).
// - clk: Clock signal.
// - reset: Reset signal to initialize memory to zero.
// - Mem_RW: Memory read/write control. (1 = Write, 0 = Read).
// - zero_extend: Selects between zero-extension or sign-extension.
// - byte_sel: 4-bit signal to select which bytes within a word to read/write.
//
// Outputs:
// - dataR: 32-bit data read from memory.
//
// Dependencies: None
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module data_mem(
    input logic [31:0] addr,       // Address input to access memory
    input logic [31:0] dataW,      // Data to write into memory
    input logic clk,               // Clock signal
    input logic reset,             // Reset signal to initialize memory
    input logic Mem_RW,            // Memory Read/Write control: 1 for write, 0 for read
    input logic zero_extend,       // Control for zero or sign extension during read
    input logic [3:0] byte_sel,    // Byte select for byte/half-word access
    output logic [31:0] dataR      // Data read from memory
);

    // Memory array with byte-sized elements. The size is 1024 bytes (8-bit memory elements).
    logic [7:0] data [1024];
    // Temporary storage for reading data from memory.
    logic [31:0] data_read;

    // Reading 4 consecutive bytes to form a 32-bit word
    assign data_read[7:0]   = data[{addr[31:2], 2'b00}];  // Read byte 0
    assign data_read[15:8]  = data[{addr[31:2], 2'b01}];  // Read byte 1
    assign data_read[23:16] = data[{addr[31:2], 2'b10}];  // Read byte 2
    assign data_read[31:24] = data[{addr[31:2], 2'b11}];  // Read byte 3

    // This always block handles reading from memory with either zero-extension or sign-extension
    always_comb begin
        if (zero_extend) begin
            // Zero-extend based on the byte select signal
            case(byte_sel)
                4'b1111: dataR = data_read;                     // Full 32-bit word read
                4'b0011: dataR = {16'b0, data_read[15:0]};      // Half-word read (lower 16 bits)
                4'b1100: dataR = {16'b0, data_read[31:16]};     // Half-word read (upper 16 bits)
                4'b0001: dataR = {24'b0, data_read[7:0]};       // Byte read (lowest byte)
                4'b0010: dataR = {24'b0, data_read[15:8]};      // Byte read (second byte)
                4'b0100: dataR = {24'b0, data_read[23:16]};     // Byte read (third byte)
                4'b1000: dataR = {24'b0, data_read[31:24]};     // Byte read (fourth byte)
                default: dataR = data_read;                     // Default: Read the full word
            endcase
        end
        else begin
            // Sign-extend based on the byte select signal
            case(byte_sel)
                4'b1111: dataR = data_read;                                  // Full 32-bit word read
                4'b0011: dataR = {{16{data_read[15]}}, data_read[15:0]};     // Sign-extended half-word read (lower 16 bits)
                4'b1100: dataR = {{16{data_read[31]}}, data_read[31:16]};    // Sign-extended half-word read (upper 16 bits)
                4'b0001: dataR = {{24{data_read[7]}}, data_read[7:0]};       // Sign-extended byte read (lowest byte)
                4'b0010: dataR = {{24{data_read[15]}}, data_read[15:8]};     // Sign-extended byte read (second byte)
                4'b0100: dataR = {{24{data_read[23]}}, data_read[23:16]};    // Sign-extended byte read (third byte)
                4'b1000: dataR = {{24{data_read[31]}}, data_read[31:24]};    // Sign-extended byte read (fourth byte)
                default: dataR = data_read;                                  // Default: Read the full word
            endcase
        end
    end

    // This always_ff block handles writing data to memory
    always_ff @(negedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize the memory with zeros
            data <= '{default : 'x};
        end
        else if (Mem_RW) begin
            // Writing to memory based on the byte select signal
            case(byte_sel)
                4'b1111: begin
                    // Write the entire 32-bit word (4 bytes)
                    data[addr]     = dataW[7:0];   // Write byte 0
                    data[addr+1]   = dataW[15:8];  // Write byte 1
                    data[addr+2]   = dataW[23:16]; // Write byte 2
                    data[addr+3]   = dataW[31:24]; // Write byte 3
                end
                4'b0011: begin
                    // Write the lower half-word (2 bytes)
                    data[addr]     = dataW[7:0];   // Write byte 0
                    data[addr+1]   = dataW[15:8];  // Write byte 1
                end
                4'b1100: begin
                    // Write the upper half-word (2 bytes)
                    data[addr+2]   = dataW[7:0];   // Write byte 2
                    data[addr+3]   = dataW[15:8];  // Write byte 3
                end
                4'b0001: data[addr]   = dataW[7:0];    // Write only the lowest byte
                4'b0010: data[addr+1] = dataW[7:0];    // Write only the second byte
                4'b0100: data[addr+2] = dataW[7:0];    // Write only the third byte
                4'b1000: data[addr+3] = dataW[7:0];    // Write only the fourth byte
                default: begin
                    // Default case: Write the entire 32-bit word
                    data[addr]     = dataW[7:0];
                    data[addr+1]   = dataW[15:8];
                    data[addr+2]   = dataW[23:16];
                    data[addr+3]   = dataW[31:24];
                end
            endcase
        end
    end

endmodule
