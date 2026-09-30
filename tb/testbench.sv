`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:53:54 PM
// Design Name: 
// Module Name: testbench
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


module testbench();
logic clk, rst;
top dut(clk, rst);
initial begin
    clk = 0;
    rst = 1;
    #20;
    rst = 0;
    #1000000;
    $finish();
end
always #10 clk = ~clk;
endmodule

