`timescale 1ns / 1ps

`include "globals.vh"

module yes(
	output [7:0] data,
	output txe,
	input clk,
	input btn
);

assign data = 8'h59;

reg [20:0] counter;
initial counter = 21'd0;

always @(posedge clk)
	counter <= counter + 1;

assign txe = (counter == 21'b0) & btn;

endmodule
