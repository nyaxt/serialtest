`timescale 1ns / 1ps

module serial_t;
// Inputs
reg clk;
reg rst;
reg rx;
reg [7:0] dat_t;
reg txe;
reg ready_rst;

// Instantiate the Unit Under Test (UUT)
serial uut (
	.clk(clk), 
    .rst(rst),
    .rx(rx),
	.dat_t(dat_t),
	.txe(txe),
    .ready_rst(ready_rst)
);

parameter BAUD_WAIT = 1_000_000_000 / 9600;

reg [7:0] test_rx;

initial begin
	$dumpfile("serial_t.lxt");
	$dumpvars(0, serial_t);

    // verify params
    $display("CLK_FREQ: %d Hz", uut.CLK_FREQ);
    $display("BAUD: %d Hz", uut.BAUD);
    $display("CLK_MUL: %d", uut.CLK_MUL);
    $display("CLK_MUL_WIDTH: %d", uut.CLK_MUL_WIDTH);

	// Initialize Inputs
    clk = 0;
    rst = 0;
    rx = 1;
	dat_t = 8'h59;
	txe = 0;
    ready_rst = 0;

    #10;
    rst = 1;
    #10;
    rst = 0;

	// Wait 10us for global reset to finish
	#10_000;

	// Add stimulus here
	txe = 1;
	#20;
	txe = 0;

    // recv some data
    test_rx = 8'h34;

    $display("BAUD_WAIT: %d", BAUD_WAIT);
    rx = 0;
    #(BAUD_WAIT);
    rx = test_rx[0];
    #(BAUD_WAIT);
    rx = test_rx[1];
    #(BAUD_WAIT);
    rx = test_rx[2];
    #(BAUD_WAIT);
    rx = test_rx[3];
    #(BAUD_WAIT);
    rx = test_rx[4];
    #(BAUD_WAIT);
    rx = test_rx[5];
    #(BAUD_WAIT);
    rx = test_rx[6];
    #(BAUD_WAIT);
    rx = test_rx[7];
    #(BAUD_WAIT);
    rx = 1;

    ready_rst = 1;
    #20;
    ready_rst = 0;

	#1_000_000;
	$finish(2);
end

always #10 clk = ~clk;

endmodule

