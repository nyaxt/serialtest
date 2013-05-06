`timescale 1ns / 1ps

module serialtx(
	output reg tx,
	input clk,
	input [7:0] data,
	input txe);

reg [21:0] baudcounter;
initial baudcounter = 21'd0;
//wire baudtick = (baudcounter == 21'd1666666);
wire baudtick = (baudcounter == 21'd166);

always @(posedge clk)
  if(baudtick)
    baudcounter <= 0;
  else
    baudcounter <= baudcounter + 1;

reg [3:0] state;
initial state = 4'h0;

// advance state
always @(posedge clk)
  if(txe)
    state <= 4'h1;
  else if(baudtick)
    if(state == 11)
      state <= 4'h0;
    else if(state != 0)
      state <= state + 1;

// output tx
always @(state[3:0])
  casex(state[3:0])
     0: tx <= 1'b1; // idle 1
	  1: tx <= 1'b1; // rts
     2: tx <= 1'b0; // start bit
	  3: tx <= data[7];
	  4: tx <= data[6];
	  5: tx <= data[5];
	  6: tx <= data[4];
	  7: tx <= data[3];
	  8: tx <= data[2];
	  9: tx <= data[1];
	 10: tx <= data[0];
	 11: tx <= 1'b1; // end bit
  endcase

endmodule


