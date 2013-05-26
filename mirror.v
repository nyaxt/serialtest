`timescale 1ns / 1ps

module mirror(
    input clk,
    input rst,
    input rx,
    output tx,
	 output led,
	 output led2
);

wire [7:0] dat;

reg txe;
reg ready_rst;

assign led = ~rx;
assign led2 = ~tx;

serial serial(
    .tx(tx),
    .dat_r(dat),
    .ready(ready),
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .dat_t(dat),
    .txe(txe),
    .ready_rst(ready_rst)
);

always @(posedge clk) begin
    if(rst) begin
        ready_rst <= 0;
        txe <= 0;
    end else if(ready) begin
        ready_rst <= 1;
        txe <= 1;
    end else begin
        ready_rst <= 0;
        txe <= 0;
    end
end

endmodule
