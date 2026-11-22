`timescale 1ns / 1ps
// ============================================================================
// File: video_test_pattern_0.sv
// Description: Video test pattern (horizontal colored bars)
// ============================================================================
module video_test_pattern_0 (
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
  import video_timing_signals_pkg::*;

  video_timing_signals_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  logic [globals_pkg::COORD_BITS-1:0] bar_width;
  logic [2:0] bar_idx;
  logic [3* globals_pkg::COLOR_BITS-1:0] bar_rgb;

  assign bar_width = cfg.h_res >> 3;  // Divide active width by 8
  always_comb begin
    if (beam_x < bar_width * 1) bar_idx = 3'd0;  // White
    else if (beam_x < bar_width * 2) bar_idx = 3'd1;  // Yellow
    else if (beam_x < bar_width * 3) bar_idx = 3'd2;  // Cyan
    else if (beam_x < bar_width * 4) bar_idx = 3'd3;  // Green
    else if (beam_x < bar_width * 5) bar_idx = 3'd4;  // Magenta
    else if (beam_x < bar_width * 6) bar_idx = 3'd5;  // Red
    else if (beam_x < bar_width * 7) bar_idx = 3'd6;  // Blue
    else bar_idx = 3'd7;  // Black

    unique case (bar_idx)
      3'd0: bar_rgb = 24'hFFFFFF;
      3'd1: bar_rgb = 24'hFFFF00;
      3'd2: bar_rgb = 24'h00FFFF;
      3'd3: bar_rgb = 24'h00FF00;
      3'd4: bar_rgb = 24'hFF00FF;
      3'd5: bar_rgb = 24'hFF0000;
      3'd6: bar_rgb = 24'h0000FF;
      3'd7: bar_rgb = 24'h000000;
    endcase

    rgb_data = de ? bar_rgb : 24'h000000;
  end

endmodule
