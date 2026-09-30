`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2024 12:55:40 AM
// Design Name: 
// Module Name: pipeline_reg2
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


module pipeline_reg2 #(parameter WIDTH = 32)(
input clk, reset, stall,
input logic [WIDTH - 1 : 0] d,
output logic [WIDTH - 1 : 0] q
    );
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end
        else if (stall) begin
            q <= 0;
        end
        else begin
            q <=  d;
        end
    end
endmodule