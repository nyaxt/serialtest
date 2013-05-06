`timescale 1ns / 1ps

module top(
    output tx,
	 output led,
    input clk,
    input btn
    );

assign led = ~tx;

wire [7:0] data;
wire txe;

yes yes(.data(data), .txe(txe), .clk(clk), .btn(btn));
serialtx serialtx(.tx(tx), .clk(clk), .data(data), .txe(txe));

endmodule
