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
  import video_timing_pkg::*;

  video_timing_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  // NOTE: Each stage of sequential logic accrues +1 clock delay.
  // Convention/design:
  // Each downstream component adds 1 cycle, this wrapper adds 1 cycle.
  // Intention: beam_x/beam_y are advanced by PIPELINE_CLK_DELAY
  // such that the displayed pixel location is corrected for the registered delays.
  // If any downstream component adds more than 1 clock cycle, this is not supported.
  // But if so, then this design must be reviewed.
  localparam logic [COORD_BITS-1:0] PIPELINE_CLK_DELAY = 2;
  video_timing_pkg::coord_t pattern_pos;
  assign pattern_pos = get_beam_lookahead(
      '{beam_x, beam_y},
      cfg,
      PIPELINE_CLK_DELAY
  );

  logic [3*COLOR_BITS-1:0] tp0_rgb;
  video_test_pattern_0 tp0 (
      .*,
      .beam_x  (pattern_pos.x),
      .beam_y  (pattern_pos.y),
      .rgb_data(tp0_rgb)
  );
  logic [3*COLOR_BITS-1:0] tp1_rgb;
  video_test_pattern_1 tp1 (
      .*,
      .beam_x  (pattern_pos.x),
      .beam_y  (pattern_pos.y),
      .rgb_data(tp1_rgb)
  );
  logic [3*COLOR_BITS-1:0] tp2_rgb;
  video_test_pattern_2 tp2 (
      .*,
      .beam_x  (pattern_pos.x),
      .beam_y  (pattern_pos.y),
      .rgb_data(tp2_rgb)
  );
  logic [3*COLOR_BITS-1:0] tp3_rgb;
  video_test_pattern_3 tp3 (
      .*,
      .beam_x  (pattern_pos.x),
      .beam_y  (pattern_pos.y),
      .rgb_data(tp3_rgb)
  );

  always_ff @(posedge pixel_clk) begin
    unique case (pattern_sel)
      2'b00: rgb_data <= tp0_rgb;
      2'b01: rgb_data <= tp1_rgb;
      2'b10: rgb_data <= tp2_rgb;
      2'b11: rgb_data <= tp3_rgb;
    endcase
  end

endmodule
