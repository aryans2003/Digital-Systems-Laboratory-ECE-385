`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2023 06:49:02 PM
// Design Name: 
// Module Name: clkdiv
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


module clkdiv(
    input logic clk_in,
    output logic clk_out
    );
    always_ff @(posedge clk_in)
        begin
        clk_out <= ~clk_out;
        end
endmodule

module clkdivKHz(
    input logic clk_in,
    output logic clk_out
);
logic[15:0] count = 15'd0;
always_ff @(posedge clk_in)
    begin
    if(count == 15'd1042)
        begin
            clk_out <= ~clk_out;
            count <= 15'd0;
        end
     else
        begin
            count <= count + 1;
        end
     end
endmodule