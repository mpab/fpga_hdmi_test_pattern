`timescale 1ns / 1ps
// ============================================================================
// File: video_test_pattern_3.sv
// Description: Video test pattern (white border inset by 1 pixel)
// ============================================================================
module video_test_pattern_3 (
    input  logic                                  pixel_clk,
    input  logic                                  pixel_rst_n,  // synchronized to pixel_clk
    input  logic [                           1:0] res_sel,
    input  logic                                  h_sync,
    input  logic                                  v_sync,
    input  logic                                  de,           // display enable
    input  logic [   globals_pkg::COORD_BITS-1:0] beam_x,
    input  logic [   globals_pkg::COORD_BITS-1:0] beam_y,
    input  logic                                  frame_start,
    input  logic                                  line_start,
    output logic [3* globals_pkg::COLOR_BITS-1:0] rgb_data      // 3x8 bits rgb = 24 bit color
);
  import globals_pkg::*;
  import video_timing_pkg::*;

  video_timing_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  logic [3* globals_pkg::COLOR_BITS-1:0] rgb_data_comb;
  always_comb begin
    rgb_data_comb = (
          (beam_x == 1) ||
          (beam_x == cfg.h_res - 2)) ||
          ((beam_y == 1) ||
          (beam_y == cfg.v_res - 2)) ? 24'hFFFFFF : 0;
  end

  // NOTE: each stage of sequential logic requires +1 compensation
  always_ff @(posedge pixel_clk) begin
    rgb_data <= rgb_data_comb;
  end

endmodule
