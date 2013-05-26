`timescale 1ns / 1ps

module mirror_t;
// Inputs
reg clk;
reg rst;
reg rx;

mirror uut(
	.clk(clk), 
    .rst(rst),
    .rx(rx)
);

parameter BAUD_WAIT = 1_000_000_000 / 9600;

reg [7:0] test_rx;

initial begin
	$dumpfile("mirror_t.lxt");
	$dumpvars(0, mirror_t);

	// Initialize Inputs
    clk = 0;
    rst = 0;
    rx = 1;

    #10;
    rst = 1;
    #10;
    rst = 0;

	// Wait 10us for global reset to finish
	#10_000;

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

	#1_000_000;
	$finish(2);
end

always #10 clk = ~clk;

endmodule

