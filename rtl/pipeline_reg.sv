`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2024 08:09:30 PM
// Design Name: 
// Module Name: pipeline_reg
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


module pipeline_reg #(parameter WIDTH = 32)(
input clk, reset, stall,
input logic [WIDTH - 1 : 0] d,
output logic [WIDTH - 1:0] q
    );
    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end
        else if (stall) begin
            q <= q;
        end
        else begin
            q <=  d;
        end
    end
endmodule
