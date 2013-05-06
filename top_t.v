`timescale 1ns / 1ps

module top_t;

// ins
reg clk;
reg btn;

// outs
wire tx;

top uut(.tx(tx), .clk(clk), .btn(btn));

initial begin
	$dumpfile("top_t.lxt");
	$dumpvars(0, uut);
	
	clk = 1'b0;
	btn = 1'b0;
	#100;

	btn = 1'b1;
	#10;
	btn = 1'b0;

	#300_000;
	$finish(2);
end

always #5 clk = ~clk;

endmodule
