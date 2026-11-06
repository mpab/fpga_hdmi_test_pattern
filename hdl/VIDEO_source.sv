`timescale 1ns / 1ps

module VIDEO_source #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10   // color space (bits)
) (
    input wire clk,
    input wire video_enable,
    input wire v_sync,
    input wire h_sync,
    input wire frame_start,
    input wire line_start,
    input wire signed [COORDSPC-1:0] beam_x,
    input wire signed [COORDSPC-1:0] beam_y,
    output logic [COLSPC-1:0] red,
    output logic [COLSPC-1:0] green,
    output logic [COLSPC-1:0] blue
);

  logic [COLSPC-1:0] _red, _green, _blue;
  VIDEO_test_pattern #(
    .COORDSPC(COORDSPC),
    .COLSPC  (COLSPC)
  ) fg (
    .red  (_red),
    .green(_green),
    .blue (_blue),
    .*
  );

  always_ff @(posedge clk) begin
    red   <= video_enable ? COLSPC'(_red) : COLSPC'(0);
    green <= video_enable ? COLSPC'(_green) : COLSPC'(0);
    blue  <= video_enable ? COLSPC'(_blue) : COLSPC'(0);
  end

endmodule
