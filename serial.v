`timescale 1ns / 1ps

module serial(
    output reg tx,
    input clk,
    input [7:0] data,
    input txe
    );
parameter CLK_FREQ = 50_000_000;
parameter BAUD = 9600;
parameter CLK_MUL = CLK_FREQ / (BAUD * 16);
parameter CLK_MUL_WIDTH = $ceil($log10(CLK_MUL)/$log10(2));

reg [(CLK_MUL_WIDTH-1):0] baudcounter;
initial baudcounter = 0;
wire baudtick16 = (baudcounter == CLK_MUL);

always @(posedge clk)
    if(baudtick16)
        baudcounter <= 0;
    else
        baudcounter <= baudcounter + 1;

reg [3:0] baudcounter2;
initial baudcounter2 = 0;
wire baudtick = baudtick16 & (baudcounter2 == 4'hf);
always @(posedge clk)
    if(baudtick16) begin
        baudcounter2 <= baudcounter2 + 1;
    end

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
always @(state[3:0] or data[7:0])
    casex(state[3:0])
        0: tx <= 1'b1; // idle 1
        1: tx <= 1'b1; // rts
        2: tx <= 1'b0; // start bit
        3: tx <= data[0];
        4: tx <= data[1];
        5: tx <= data[2];
        6: tx <= data[3];
        7: tx <= data[4];
        8: tx <= data[5];
        9: tx <= data[6];
        10: tx <= data[7];
        11: tx <= 1'b1; // end bit
    endcase

endmodule
