`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:36:31 PM
// Design Name: RISC-V Pipeline Processor
// Module Name: top
// Project Name: RISC-V 5-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: 
// This module implements a RISC-V 5-stage pipeline processor with hazard 
// detection and forwarding units. It includes program counter logic, 
// instruction memory, register file, ALU, data memory, and control signals 
// to handle stalls, branch prediction, and forwarding for data hazards.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top #(parameter WIDTH = 32)(
    input logic clk, reset   // Clock and reset signals
);
    // Declaration of internal signals
    logic [WIDTH - 1 : 0] data1_2, fw_mux1_out, fw_mux2_out, fw_mux2_out2, PC_out2, PC_out3, PC_out4, PC_out5;
    logic [WIDTH - 1 : 0] data2_2, data2_3, alu_out2, alu_out3, data_R2, immediate2;
    logic [WIDTH - 1 : 0] instruction1, instruction2, instruction3, instruction4, instruction5, PC_in, PC_plus4, PC_out;
    logic [WIDTH - 1 : 0] RB_mux_out, operand_a, operand_b, immediate, data1, data2, alu_out, dataR;
    logic [3:0] byte_sel; // Byte select signal for data memory access
    logic [2:0] funct;    // Function field from instruction (funct3)
    bit stall, stallA, stallB, stall2, Flush, stallA_2, stallB_2; // Stall and control signals
    bit hazard_A0, hazard_A1, hazard_B0, hazard_B1; // Hazard detection signals
    bit wr_en, mem_RW, operand_a_sel, Lt, Eq, Br_taken, Jump; // Write enable, memory read/write, branch/jump signals

    // Flush pipeline on a jump or branch taken
    assign Flush = (|Jump); 

    // Branch condition based on funct3 and comparison results (Eq, Lt)
    assign Br_taken = ((~funct[0] & ~funct[2] & Eq) | (funct[0] & ~funct[2] & ~Eq) | (~funct[0] & funct[2] & Lt) | (funct[0] & funct[2] & ~Lt))? 1'b1 : 1'b0;

    // Jump signal logic: branch taken or jump instruction
    assign Jump = ((Br_taken & instruction3[6] & ~instruction3[4]) | (instruction3[2] & instruction3[6] & ~instruction3[4])) ? 1'b1 : 1'b0;

    // Operand A selection logic: based on instruction fields
    assign operand_a_sel = ((~instruction3[5] & instruction3[4] & instruction3[2]) | (~instruction3[2] & instruction3[5] & instruction3[6]) | (instruction3[3] & instruction3[5] & instruction3[6])) ? 1'b1 : 1'b0;

    // Memory read/write enable based on instruction type (funct3)
    assign mem_RW = (~instruction4[6] & instruction4[5]& ~instruction4[4]) ? 1'b1 : 1'b0;

    // Write enable for register file based on instruction type
    assign wr_en = (~(instruction5[5] & ~instruction5[4]& ~instruction5[2])) ? 1'b1 : 1'b0;

    // Increment PC by 4 for the next instruction fetch
    assign PC_plus4 = PC_out + 4;

    // Extract funct3 from the instruction
    assign funct = instruction3[14:12];

    // Stall signals based on hazard detection and instruction type
    assign stall = ((hazard_A0 | hazard_B0) && (instruction4[6:2] == 0)) ? 1'b1 : 1'b0;
    assign stallA = ((hazard_A0) && (instruction4[6:2] == 0)) ? 1'b1 : 1'b0;
    assign stallB = ((hazard_B0) && (instruction4[6:2] == 0)) ? 1'b1 : 1'b0;

    // Multiplexer for selecting the next PC value (PC+4 or branch target)
    mux_2x1 m3(PC_plus4, alu_out, Jump, PC_in); 
    // Program counter logic
    program_counter pc1(clk, reset, PC_in, PC_out);


    // Instruction memory
    inst_mem #(32) imem(PC_out - 32'h80000000, instruction1);

    // Pipeline register for fetching instruction
    pipeline_reg #(32) d1(clk, (reset || Flush), stall, instruction1, instruction2);
    
    // Register file
    reg_file rf1(clk, reset, wr_en, instruction2[19:15], instruction2[24:20], instruction5[11:7], RB_mux_out, data1, data2);

    // Immediate generator
    imm_gen imm(instruction2, immediate);

    // Pipeline registers for data forwarding and hazard control
    pipeline_reg #(32) d2(clk, (reset || Flush), stall, data1, data1_2);
    pipeline_reg #(32) d3(clk, (reset || Flush), stall, data2, data2_2);
    pipeline_reg #(32) d20(clk, reset, stall, PC_out, PC_out2);
    pipeline_reg #(32) d4(clk, (reset || Flush), stall, immediate, immediate2);
    pipeline_reg #(32) d5(clk, (reset || Flush), stall, instruction2, instruction3);
    pipeline_reg #(32) d21(clk, (reset || Flush), stall, PC_out2, PC_out3);

    // Forwarding units to handle data hazards
    forwarding_unit  fw1(instruction3, instruction4, hazard_A0, hazard_B0);
    forwarding_unit  fw2(instruction3, instruction5, hazard_A1, hazard_B1);

    // Multiplexers for forwarding data in case of hazards
    mux fw_mux1(data1_2, alu_out2, alu_out3, data_R2, {stallA_2, hazard_A1, hazard_A0}, fw_mux1_out);
    mux fw_mux2(data2_2, alu_out2, alu_out3, data_R2, {stallB_2, hazard_B1, hazard_B0}, fw_mux2_out);

    // Operand A selection (register value or PC)
    mux_2x1 m1(fw_mux1_out, PC_out3, operand_a_sel, operand_a);

    // Operand B selection (register value or immediate)
    mux_2x1 m2(fw_mux2_out, immediate2, (~instruction3[4] | instruction3[2] | (instruction3[2] ^  instruction3[4] ^ instruction3[5])), operand_b);

    // Branch comparison logic
    branch_com branch(fw_mux1_out, fw_mux2_out, funct[1], Eq, Lt);

    // ALU operation
    alu_logic alu(operand_a, operand_b, {instruction3[5],  instruction3[4], instruction3[2], instruction3[14:12], instruction3[30]}, alu_out);

    // Pipeline registers for ALU results
    pipeline_reg2 #(32) d6(clk, reset, stall, instruction3, instruction4);
    pipeline_reg #(32) d22(clk, reset, stall, PC_out3, PC_out4);
    pipeline_reg2 #(32) d7(clk, reset, stall, data2_2, data2_3);
    pipeline_reg2 #(32) d8(clk, reset, stall, alu_out, alu_out2);
    pipeline_reg #(1) d30(clk, reset, 1'b0, stallA, stallA_2);
    pipeline_reg #(1) d31(clk, reset, 1'b0, stallB, stallB_2);
    pipeline_reg #(1) d15(clk, reset, 1'b0, stall, stall2);
    pipeline_reg #(32) d23(clk, reset, stall, PC_out4, PC_out5);
    

    pipeline_reg #(32) d35(clk, reset, 1'b0, fw_mux2_out, fw_mux2_out2);
    // Data memory control signals
    dm_signal dms(alu_out2[1:0], instruction4[13:12], byte_sel);

    // Data memory
    data_mem dmem(alu_out2, fw_mux2_out2, clk, reset, mem_RW, instruction4[14], byte_sel, dataR);

    // Pipeline registers for memory and write-back stage
    pipeline_reg #(32) d9(clk, reset, 1'b0, instruction4, instruction5);
    pipeline_reg #(32) d10(clk, reset, 1'b0, alu_out2, alu_out3);
    pipeline_reg #(32) d11(clk, reset, 1'b0, dataR, data_R2);

    // Write-back stage: select between ALU result, data memory result and PC+4
       mux_4x1 m4(data_R2, alu_out3, (PC_out5 + 4), 32'bz, {instruction5[6], instruction5[4]}, RB_mux_out);
    logic [31:0] data1_M, data2_M, data1_W, data2_W;
    pipeline_reg #(32) d50(clk, reset, 1'b0, operand_a, data1_M);
    pipeline_reg #(32) d51(clk, reset, 1'b0, operand_b, data2_M);
    pipeline_reg #(32) d52(clk, reset, 1'b0, data1_M, data1_W);
    pipeline_reg #(32) d53(clk, reset, 1'b0, data2_M, data2_W);
    tracer tracer_ip (       
.clk_i(clk),
.rst_ni(reset),
.hart_id_i(32'b0),
.rvfi_valid(1'b1),
.rvfi_insn_t(instruction5),
.rvfi_rs1_addr_t(instruction5[19:15]),
.rvfi_rs2_addr_t(instruction5[24:20]),
.rvfi_rs1_rdata_t(data1_W),
.rvfi_rs2_rdata_t(data2_W),
.rvfi_rd_addr_t(instruction5[11:7]) ,
.rvfi_rd_wdata_t(RB_mux_out),
.rvfi_pc_rdata_t(PC_out5),
.rvfi_pc_wdata_t(PC_out5 + 4),
.rvfi_mem_addr(0),
.rvfi_mem_rmask(0),
.rvfi_mem_wmask(0),
.rvfi_mem_rdata(0),
.rvfi_mem_wdata(0)
);
endmodule
