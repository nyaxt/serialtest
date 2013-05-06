`timescale 1ns / 1ps

module serialtx_t;
// Inputs
reg clk;
reg [7:0] data;
reg txe;

// Outputs
wire [3:0] state = uut.state;
wire [31:0] baudcounter = uut.baudcounter;
wire tx;

// Instantiate the Unit Under Test (UUT)
serialtx uut (
	.tx(tx), 
	.clk(clk), 
	.data(data), 
	.txe(txe)
);

initial begin
	$dumpfile("serialtx_t.lxt");
	$dumpvars(0, serialtx_t);

	// Initialize Inputs
	data = 8'h59;
	txe = 0;
	uut.baudcounter = 21'd0;

	// Wait 100 ns for global reset to finish
	#100;

	// Add stimulus here
	txe = 1;
	#20;
	txe = 0;

	/*
	#2000;

	txe = 1;
	#20;
	txe = 0;
	*/

	#200_000;
	$finish(2);
end

always begin
	#5;
	clk = 1'b0;
	#5;
	#5;
	clk = 1'b1;
	#5;
end

endmodule

