`timescale 1ns / 1ps

module sim #(
    H_RES = 640,
    V_RES = 480,
    VID_COORD_BITS = 16,  // coordinate space (bits)
    VID_COLOR_BITS = 10  // color space (bits)
) (
    input logic clk,
    input logic reset,
    output logic video_enable,
    output logic v_sync,
    output logic h_sync,
    output logic frame_start,
    output logic line_start,
    output logic signed [11:0] beam_x,
    output logic signed [11:0] beam_y,
    output logic [VID_COLOR_BITS-1:0] red,
    output logic [VID_COLOR_BITS-1:0] green,
    output logic [VID_COLOR_BITS-1:0] blue
);
  logic signals_valid, beam_at_zero, h_blank, v_blank;  // unused
  videotiming_signals video_signals (.*);
  videosource source (.*);
endmodule
