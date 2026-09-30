`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:34:26 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input logic [31:0] instruction,   // Input: 32-bit instruction
    output logic [31:0] out           // Output: Immediate value generated from the instruction
);

    // Opcode and func3 fields from the instruction
    logic [6:0] opcode;
    logic [2:0] func3;

    // Constants for different instruction types based on their opcodes
    logic [6:0] R_type, I_type, S_type, B_type, LOAD, LUI, AUIPC, JAL, JALR;

    // Extracting the opcode and func3 fields from the instruction
    assign opcode = instruction[6:0];    // Opcode is bits [6:0]
    assign func3 = instruction[14:12];   // func3 is bits [14:12]

    // Defining opcode values for different RISC-V instruction types
    assign R_type = 7'b0110011;  // R-type instructions (e.g., add, sub)
    assign I_type = 7'b0010011;  // I-type instructions (e.g., immediate arithmetic)
    assign S_type = 7'b0100011;  // S-type instructions (e.g., store)
    assign B_type = 7'b1100011;  // B-type instructions (e.g., branch)
    assign LOAD = 7'b0000011;    // Load instructions
    assign LUI = 7'b0110111;     // Load Upper Immediate (LUI)
    assign AUIPC = 7'b0010111;   // Add Upper Immediate to PC (AUIPC)
    assign JAL = 7'b1101111;     // Jump and Link (JAL)
    assign JALR = 7'b1100111;    // Jump and Link Register (JALR)

    // Generate immediate values based on the instruction type (opcode)
    always_comb begin
        case (opcode)
            R_type: begin
                out = 32'b0;  // R-type instructions do not use immediate values
            end

            I_type: begin
                // For shift instructions (func3 = 001 or 101), only take the immediate bits [24:20]
                case (func3)
                    3'b001: out = {23'b0, instruction[24:20]};  // Immediate for shift left (SLLI)
                    3'b101: out = {23'b0, instruction[24:20]};  // Immediate for shift right (SRLI/SRAI)
                    default: out = {{20{instruction[31]}}, instruction[31:20]}; // Sign-extended immediate for other I-type instructions
                endcase
            end

            S_type: begin
                // S-type instructions (store): concatenate bits [31:25] and [11:7] to form the immediate
                out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end

            B_type: begin
                // B-type instructions (branch): concatenate bits [31], [7], [30:25], and [11:8], with a 0 as the least significant bit
                out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end

            LOAD: begin
                // Load instructions use the I-type immediate format (sign-extended bits [31:20])
                out = {{20{instruction[31]}}, instruction[31:20]};
            end

            LUI: begin
                // LUI: upper 20 bits are from the instruction, with 12 lower bits set to 0
                out = {instruction[31:12], 12'b0};
            end

            AUIPC: begin
                // AUIPC: same format as LUI, upper 20 bits from the instruction and 12 lower bits set to 0
                out = {instruction[31:12], 12'b0};
            end

            JAL: begin
                // JAL: concatenate bits [31], [19:12], [20], [30:21], and add a 0 as the least significant bit
                out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end

            JALR: begin
                // JALR: same format as I-type (sign-extended bits [31:20])
                out = {{20{instruction[31]}}, instruction[31:20]};
            end

        endcase
    end

endmodule
