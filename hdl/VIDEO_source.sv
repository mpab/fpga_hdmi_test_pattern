`timescale 1ns / 1ps
// ============================================================================
// File: video_source.sv
// Description: Wrapper for video source(s)
// ============================================================================
module video_source (
    input  logic                                 pixel_clk,
    input  logic                                 pixel_rst_n,  // synchronized to pixel_clk
    input  logic [                          1:0] res_sel,
    input  logic [                          1:0] pattern_sel,
    input  logic                                 h_sync,
    input  logic                                 v_sync,
    input  logic                                 de,           // display enable
    input  logic [  globals_pkg::COORD_BITS-1:0] beam_x,
    input  logic [  globals_pkg::COORD_BITS-1:0] beam_y,
    input  logic                                 frame_start,
    input  logic                                 line_start,
    output logic [3*globals_pkg::COLOR_BITS-1:0] rgb_data      // 3x8 bits rgb = 24 bit color
);
  import globals_pkg::*;
  import video_timing_signals_pkg::*;

  logic [3*globals_pkg::COLOR_BITS-1:0] tp0_rgb;
  video_test_pattern_0 tp0 (
      .*,
      .rgb_data(tp0_rgb)
  );
  logic [3*globals_pkg::COLOR_BITS-1:0] tp1_rgb;
  video_test_pattern_1 tp1 (
      .*,
      .rgb_data(tp1_rgb)
  );

  // NOTE: combinational logic works on xilinx, but not on mister
  always_ff @(posedge pixel_clk) begin
    rgb_data <= pattern_sel[0] ? tp1_rgb : tp0_rgb;
  end

endmodule
