`timescale 1ns / 1ps

module serial_wb_if_t;
// Inputs
reg clk;
reg rst;
reg rx;

reg [7:0] wb_dat_i;
reg wb_ack_i;

serial_wb_if uut(
	.clk(clk), 
    .rst(rst),
    .serial_rx(rx),

    .wb_dat_i(wb_dat_i),
    .wb_ack_i(wb_ack_i)
);

parameter BAUD_WAIT = 1_000_000_000 / 9600;

reg [7:0] test_rx;

initial begin
	$dumpfile("serial_wb_if_t.lxt");
	$dumpvars(0, serial_wb_if_t);

	// Initialize Inputs
    clk = 0;
    rst = 0;
    rx = 1;
    wb_dat_i = 8'hab;
    wb_ack_i = 1'b1;

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

