`timescale 1ns / 1ps

// csr r/w via serial
/*
  ====== protocol ======

  single read:
  -> [addr]
  <- [data]

  single write:
  -> [0x80 | addr] [data]
  <- [data] 
*/
module csrprot(
    output serial_tx,
    output [7:0] csr_dat_r,
    output [6:0] csr_adr,
    output csr_we,
    input clk,
    input rst,
    input serial_rx,
    input [7:0] csr_dat_w,
    input csr_ready
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

// fsm
parameter ST_IDLE = 2'h0;
parameter ST_READ_WAIT = 2'h1;
parameter ST_GET_DATA = 2'h2;
parameter ST_WRITE_WAIT = 2'h3;

reg [6:0] addr_ff;
assign csr_adr = addr;

reg [7:0] data_ff;
assign csr_dat_w = data;

reg csr_we_ff;

wire write_cmd = dat_r[7];

reg [1:0] state;
always @(posedge clk) begin
    csr_we <= 0;
    dat_t_ff <= 8'h00;
    txe_ff <= 0;
    ready_rst_ff <= 0; 

    if(rst) begin
        state <= ST_IDLE;
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
                    end
                end
            end
            ST_READ_WAIT: begin
                if(csr_ready) begin
                    dat_t_ff <= csr_dat_w;
                    txe_ff <= 1;
                end
            end
            ST_GET_DATA: begin
                if(ready) begin
                    ready_rst_ff <= 1;
                    data_ff <= dat_r;
                    csr_we <= 1;
                end
            end
            ST_WRITE_WAIT: begin
                                
            end
        endcase
    end
end

endmodule

