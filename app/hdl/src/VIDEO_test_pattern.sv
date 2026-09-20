`timescale 1ns / 1ps

// pattern taken from here
// https:// www.fpga4fun.com/HDMI.html
// https:// www.youtube.com/watch?v = sMOZxOCfkBU
// https:// github.com/dominic-meads/HDMI_FPGA/tree/master/HDMI_FPGA4fun

module VIDEO_test_pattern #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10
) (
    input wire clk,
    input wire signed [COORDSPC-1:0] beam_x,
    input wire signed [COORDSPC-1:0] beam_y,
    output logic [COLSPC-1:0] red,
    output logic [COLSPC-1:0] green,
    output logic [COLSPC-1:0] blue
);
  wire [COLSPC-1:0] SX = beam_x[COLSPC-1:0];
  wire [COLSPC-1:0] SY = beam_y[COLSPC-1:0];
  wire [COLSPC-1:0] W = {COLSPC{SX[7:0] == SY[7:0]}};
  wire [COLSPC-1:0] A = {COLSPC{SX[7:5] == 3'h2 && SY[7:5] == 3'h2}};

  always_ff @(posedge clk) begin
    red   <= ({SX[5:0] & {6{SY[4:3] == ~SX[4:3]}}, 4'b0} | W) & ~A;
    green <= (SX & {COLSPC{SY[6]}} | W) & ~A;
    blue  <= SY | W | A;
  end
endmodule
