`timescale 1ns / 1ps
// ============================================================================
// File: video_test_pattern_1.sv
// Description: Video test pattern (colored squares)
// ============================================================================
module video_test_pattern_1 (
    input  logic                                  pixel_clk,
    input  logic                                  pixel_rst_n,  // synchronized to pixel_clk
    input  logic [                           1:0] res_sel,      // unused
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

  wire [globals_pkg::COLOR_BITS-1:0] SX = beam_x[globals_pkg::COLOR_BITS-1:0];
  wire [globals_pkg::COLOR_BITS-1:0] SY = beam_y[globals_pkg::COLOR_BITS-1:0];
  wire [globals_pkg::COLOR_BITS-1:0] W = {globals_pkg::COLOR_BITS{SX[7:0] == SY[7:0]}};
  wire  [ globals_pkg::COLOR_BITS-1:0] A = { globals_pkg::COLOR_BITS{SX[7:5] == 3'h2 && SY[7:5] == 3'h2}};

  logic [globals_pkg::COLOR_BITS-1:0] red;
  logic [globals_pkg::COLOR_BITS-1:0] green;
  logic [globals_pkg::COLOR_BITS-1:0] blue;

  always_comb begin
    red   = ({SX[5:0] & {6{SY[4:3] == ~SX[4:3]}}, 2'b0} | W) & ~A;
    green = (SX & {globals_pkg::COLOR_BITS{SY[6]}} | W) & ~A;
    blue  = SY | W | A;
  end

  // NOTE: each stage of sequential logic requires +1 compensation
  always_ff @(posedge pixel_clk) begin
    rgb_data <= {red, green, blue};
  end

endmodule
