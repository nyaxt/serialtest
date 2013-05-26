`timescale 1ns / 1ps

module serial(
    output reg tx,
    output reg [7:0] dat_r,
    output reg ready,
    input clk,
    input rst,
    input rx,
    input [7:0] dat_t,
    input txe,
    input ready_rst
    );
parameter CLK_FREQ = 50_000_000;
parameter BAUD = 9600;
parameter CLK_MUL = CLK_FREQ / (BAUD * 16);
parameter CLK_MUL_WIDTH = 15; //$ceil($log10(CLK_MUL)/$log10(2));

// clk multiplier: baudtick16 / baudtick
reg [(CLK_MUL_WIDTH-1):0] baudcounter;
wire baudtick16 = (baudcounter == (CLK_MUL-1));

always @(posedge clk)
    if(rst | baudtick16)
        baudcounter <= 0;
    else
        baudcounter <= baudcounter + 1;

reg [3:0] baudcounter2;
wire baudtick = baudtick16 & (baudcounter2 == 4'h0);
always @(posedge clk)
    if(rst)
        baudcounter2 <= 0;
    else if(baudtick16)
        baudcounter2 <= baudcounter2 + 1;

// ====== Tx ======
reg [7:0] dat_t_ff;

reg [3:0] tx_state;

// advance tx_state
always @(posedge clk)
    if(rst)
        tx_state <= 4'h0;
    else if(txe) begin
        tx_state <= 4'h1;
        dat_t_ff <= dat_t;
    end else if(baudtick)
        if(tx_state == 11)
            tx_state <= 4'h0;
        else if(tx_state != 0)
            tx_state <= tx_state + 1;

// output tx
always @(tx_state[3:0] or dat_t_ff[7:0])
    casex(tx_state[3:0])
        0: tx <= 1'b1; // idle 1
        1: tx <= 1'b1; // rts
        2: tx <= 1'b0; // start bit
        3: tx <= dat_t_ff[0];
        4: tx <= dat_t_ff[1];
        5: tx <= dat_t_ff[2];
        6: tx <= dat_t_ff[3];
        7: tx <= dat_t_ff[4];
        8: tx <= dat_t_ff[5];
        9: tx <= dat_t_ff[6];
        10: tx <= dat_t_ff[7];
        11: tx <= 1'b1; // end bit
		  default: tx <= 1'b1;
    endcase

// ====== Rx ======
reg rx_active;
reg [7:0] rx_counter;

always @(posedge clk) begin
    if(ready_rst)
        ready <= 0;

    if(rst) begin
        rx_active <= 0;
        rx_counter <= 8'h00;
        dat_r <= 8'h0;
        ready <= 0;
    end else if(!rx_active) begin
        // start bit
        if(rx == 1'b0) begin
            rx_active <= 1;
            rx_counter <= 8'h00;
            ready <= 0;
        end
    end else if(baudtick16) begin
        rx_counter <= rx_counter + 1;
        
        // try read at middle
        if(rx_counter[3:0] == 4'h8) begin
            case(rx_counter[7:4])
                0: begin
                    // reset if false start
                    if(rx == 1'b1)
                        rx_active <= 0;
                end
                // end of cycle
                9: begin
                    rx_active <= 0;
						  ready <= 1;
                end
                default: begin
                    dat_r <= {rx, dat_r[7:1]};

                    // set ready on last bit recv
                    // if(rx_counter[7:4] == 8)
                        
                end 
            endcase
        end
    end
end

endmodule
