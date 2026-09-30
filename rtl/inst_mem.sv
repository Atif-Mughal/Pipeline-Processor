`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 01:43:42 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem #(PC_WIDTH = 32)(
    input logic [PC_WIDTH - 1:0] addr,  // Input: Program Counter (PC) address for instruction fetch
    output logic [31:0] dataR           // Output: 32-bit instruction data read from memory
);

    logic [31:0] inst_memory[12000];      // Instruction memory array, 256 words of 32-bit width

    // Initial block to load the instructions from an external file into the instruction memory
    initial begin
        $readmemh("../sim/seed/test.hex", inst_memory);  // Read instructions from the hex file "instructions.mem"
    end

    // Assign the fetched instruction to dataR
    // The PC address is divided by 4 (shifted right by 2 bits) to index the word-aligned instruction memory
    assign dataR = inst_memory[addr[PC_WIDTH - 1:2]];

endmodule
