`timescale 1ns / 1ps

// wishbone csr r/w via serial
/*
  ====== protocol ======

  single read:
  -> [addr]
  <- [data]

  single write:
  -> [0x80 | addr] [data]
  <- [data] 
*/
module serial_wb_if(
    input clk,
    input rst,

    output serial_tx,
    input serial_rx,

    output [6:0] wb_adr_o,
    input [7:0] wb_dat_i,
    output [7:0] wb_dat_o,
    output wb_we_o,
    output wb_stb_o,
    input wb_ack_i,
    output wb_cyc_o
    );

// serial rx/tx
reg [7:0] dat_t_ff;
reg txe_ff;
reg ready_rst_ff;
wire [7:0] dat_r;
wire ready;

serial serial(
    .tx(serial_tx),
    .dat_r(dat_r),
    .ready(ready),
    .clk(clk),
    .rst(rst),
    .rx(serial_rx),
    .dat_t(dat_t_ff),
    .txe(txe_ff),
    .ready_rst(ready_rst_ff)
);

// wishbone if
reg [6:0] addr_ff;
assign wb_adr_o = addr_ff;

reg [7:0] data_ff;
assign wb_dat_o = data_ff;

reg wb_we_ff;
assign wb_we_o = wb_we_ff;

reg wb_stb_ff;
assign wb_stb_o = wb_stb_ff;

reg wb_cyc_ff;
assign wb_cyc_o = wb_cyc_ff;

// fsm
parameter ST_IDLE = 2'h0;
parameter ST_READ_WAIT = 2'h1;
parameter ST_GET_DATA = 2'h2;
parameter ST_WRITE_WAIT = 2'h3;

wire write_cmd = dat_r[7];

reg [1:0] state;
always @(posedge clk) begin
    dat_t_ff <= 8'h00;
    txe_ff <= 0;
    ready_rst_ff <= 0; 

    wb_we_ff <= 0;
    wb_stb_ff <= 0;

    if(rst) begin
        state <= ST_IDLE;
        wb_cyc_ff <= 0;
    end else begin
        case(state)
            ST_IDLE: begin
                if(ready) begin
                    ready_rst_ff <= 1;

                    addr_ff <= dat_r[6:0];
                    if(write_cmd) begin
                        state <= ST_GET_DATA;
                    end else begin
                        state <= ST_READ_WAIT;
                        wb_stb_ff <= 1;
                        wb_cyc_ff <= 1;
                    end
                end
            end
            ST_READ_WAIT: begin
                if(wb_ack_i) begin
                    dat_t_ff <= wb_dat_i;
                    txe_ff <= 1;

                    wb_cyc_ff <= 0;

                    state <= ST_IDLE;
                end
            end
            ST_GET_DATA: begin
                if(ready) begin
                    ready_rst_ff <= 1;

                    data_ff <= dat_r;
                    wb_we_ff <= 1;
                    wb_stb_ff <= 1;
                    wb_cyc_ff <= 1;

                    state <= ST_WRITE_WAIT;
                end
            end
            ST_WRITE_WAIT: begin
                if(wb_ack_i) begin
                    dat_t_ff <= data_ff;
                    txe_ff <= 1;

                    wb_cyc_ff <= 0;

                    state <= ST_IDLE;
                end
            end
        endcase
    end
end

endmodule

