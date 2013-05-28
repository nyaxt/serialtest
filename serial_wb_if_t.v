`timescale 1ns / 1ps

module serial_wb_if_t;
// Inputs
reg clk;
reg rst;
reg rx;

wire [6:0] wb_adr;
wire [7:0] wb_dat_ms;
wire [7:0] wb_dat_sm;
wire wb_we;
wire wb_stb;
wire wb_ack;
wire wb_cyc;

serial_wb_if uut(
	.clk(clk), 
    .rst(rst),
    .serial_rx(rx),

    .wb_adr_o(wb_adr),
    .wb_dat_i(wb_dat_sm),
    .wb_dat_o(wb_dat_ms),
    .wb_we_o(wb_we),
    .wb_stb_o(wb_stb),
    .wb_ack_i(wb_ack),
    .wb_cyc_o(wb_cyc));

csr csr(
    .clk(clk),
    .rst(rst),

    .wb_adr_i(wb_adr),
    .wb_dat_i(wb_dat_ms),
    .wb_dat_o(wb_dat_sm),
    .wb_we_i(wb_we),
    .wb_stb_i(wb_stb),
    .wb_ack_o(wb_ack),
    .wb_cyc_i(wb_cyc));

parameter BAUD_WAIT = 1_000_000_000 / 9600;

reg [7:0] test_rx;

task recv_byte;
    input [7:0] byte;
    begin
        rx = 0;
        #(BAUD_WAIT);
        rx = byte[0];
        #(BAUD_WAIT);
        rx = byte[1];
        #(BAUD_WAIT);
        rx = byte[2];
        #(BAUD_WAIT);
        rx = byte[3];
        #(BAUD_WAIT);
        rx = byte[4];
        #(BAUD_WAIT);
        rx = byte[5];
        #(BAUD_WAIT);
        rx = byte[6];
        #(BAUD_WAIT);
        rx = byte[7];
        #(BAUD_WAIT);
        rx = 1;
        #(BAUD_WAIT);
    end
endtask

initial begin
	$dumpfile("serial_wb_if_t.lxt");
	$dumpvars(0, serial_wb_if_t);

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
    recv_byte(8'h82);
    recv_byte(8'hab);

    $display("BAUD_WAIT: %d", BAUD_WAIT);

	#1_000_000;
	$finish(2);
end

always #10 clk = ~clk;

endmodule

