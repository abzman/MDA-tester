`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:41:16 07/05/2020 
// Design Name: 
// Module Name:    mda 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mda(
    input clk,
    input rst,
    output reg [9:0] x,
    output reg [9:0] y,
    output valid,
    output hsync,
    output vsync,
    output reg newframe, // 1 clock pulse when new frame starts
    output reg newline // 1 clock pulse when new line starts
    );
    
reg clk16; // 16.257MHz signal
reg [31:0]	ctr;
initial ctr = 0;

assign hsync = x > (720 + 10) && x <= (720 + 10 + 135); //720px viewable, 10tks porch, 135tks sync, 17tks porch
assign vsync = y < (350 + 0) || y >= (350 + 0 + 16); //350lines viewable, 0tks porch, 16 lines sync, 4lines porch
assign valid = (x < 720) && (y < 350);

always @(posedge clk) begin
  newframe <= 0;
  newline <= 0;
  if (rst) begin
    x <= 10'b0;
    y <= 10'b0;
    clk16 <= 1'b0;
    newframe <= 1;
    newline <= 1;
  end else begin
    {clk16, ctr} <= ctr + 32'd1396465667; // creates 16.257MHz signal
    if (clk16 == 1'b1) begin
      if (x < 10'd881) begin //all ticks wide -1
        x <= x + 1'b1;
      end else begin
        x <= 10'b0;
        newline <= 1;
        if (y < 10'd369) begin //all lines tall -1
          y <= y + 1'b1;
        end else begin
          y <= 10'b0;
          newframe <= 1;
        end
      end
    end
  end
end

endmodule
