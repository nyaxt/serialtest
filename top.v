`timescale 1ns / 1ps

module top(
    input clk,
    input rst,

    output tx,
    input rx,
    output led,
    output led2
    );

assign led = ~tx;
assign led2 = ~rx;

wire [6:0] wb_adr;
wire [7:0] wb_dat_ms;
wire [7:0] wb_dat_sm;
wire wb_we;
wire wb_stb;
wire wb_ack;
wire wb_cyc;

serial_wb_if uut(
    .clk(clk), 
    .rst(rst),
    .serial_rx(rx),
    .serial_tx(tx),

    .wb_adr_o(wb_adr),
    .wb_dat_i(wb_dat_sm),
    .wb_dat_o(wb_dat_ms),
    .wb_we_o(wb_we),
    .wb_stb_o(wb_stb),
    .wb_ack_i(wb_ack),
    .wb_cyc_o(wb_cyc));

csr csr(
    .clk(clk),
    .rst(rst),

    .wb_adr_i(wb_adr),
    .wb_dat_i(wb_dat_ms),
    .wb_dat_o(wb_dat_sm),
    .wb_we_i(wb_we),
    .wb_stb_i(wb_stb),
    .wb_ack_o(wb_ack),
    .wb_cyc_i(wb_cyc));

endmodule
