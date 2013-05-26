`timescale 1ns / 1ps

module serial_t;
// Inputs
reg clk;
reg [7:0] data;
reg txe;

// Instantiate the Unit Under Test (UUT)
serial uut (
	.clk(clk), 
	.data(data), 
	.txe(txe)
);

initial begin
	$dumpfile("serial_t.lxt");
	$dumpvars(0, serial_t);

    // verify params
    $display("CLK_FREQ: %d Hz", uut.CLK_FREQ);
    $display("BAUD: %d Hz", uut.BAUD);
    $display("CLK_MUL: %d", uut.CLK_MUL);
    $display("CLK_MUL_WIDTH: %d", uut.CLK_MUL_WIDTH);

	// Initialize Inputs
	data = 8'h59;
	txe = 0;
    clk = 0;

	// Wait 10us for global reset to finish
	#10_000;

	// Add stimulus here
	txe = 1;
	#20;
	txe = 0;

	#1_000_000;
	$finish(2);
end

always #5 clk = ~clk;

endmodule

