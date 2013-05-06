`timescale 1ns / 1ps

module top(
    output tx,
    input clk,
	 input rst,
    input btn
    );

wire [7:0] data;
wire txe;

yes yes(.data(data), .txe(txe), .clk(clk), .rst(rst), .btn(btn));
serialtx serialtx(.tx(tx), .clk(clk), .data(data), .txe(txe));

endmodule
