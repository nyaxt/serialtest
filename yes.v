`timescale 1ns / 1ps

`include "globals.vh"

module yes(
    output [7:0] data,
    output txe,
	 input clk,
	 input rst,
    input btn
    );

assign data = 8'h59;

reg [20:0] counter;
always @(posedge clk)
  if(rst)
    counter <= 21'b0;
  else
    counter <= counter + 1;

assign tx = (counter == 21'b0) & btn;

endmodule
