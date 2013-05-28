// configuration status registers via wishbone bus
module csr #(
    parameter NUM_CH = 4,
    parameter VOL_WIDTH = (8*2*NUM_CH),
    parameter ADDR_OFFSET_VOLS = 8'h00
)(
    input clk,
    input rst,

    output [(VOL_WIDTH-1):0] vol,

    input [6:0] wb_adr_i,
    input [7:0] wb_dat_i,
    output [7:0] wb_dat_o,
    input wb_we_i,
    input wb_stb_i,
    output wb_ack_o,
    input wb_cyc_i);

reg [(VOL_WIDTH-1):0] vol_ff;
assign vol = vol_ff;

reg wb_ack_ff;
assign wb_ack_o = wb_ack_ff;

reg [7:0] wb_dat_ff;
assign wb_dat_o = wb_dat_ff;

integer i;

always @(posedge clk) begin
    wb_ack_ff <= 0;
    wb_dat_ff <= 8'h00;

    if(rst) begin
        vol_ff <= {(VOL_WIDTH){1'b0}};
    end else if(wb_stb_i & wb_cyc_i) begin
        wb_ack_ff <= 1;

        for(i = 0; i < (VOL_WIDTH/8); i = i + 1) begin
            if(wb_we_i) begin
                // write cmd
                if(wb_adr_i == ADDR_OFFSET_VOLS + i)
                    vol_ff[i*8 +:8] <= wb_dat_i;
            end else begin
                // read cmd
                if(wb_adr_i == ADDR_OFFSET_VOLS + i)
                    wb_dat_ff <= vol_ff[i*8 +:8];
            end
        end
    end
end

endmodule
