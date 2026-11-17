`timescale 1ns / 1ps
// ============================================================================
// File: video_test_pattern_1.sv
// Description: Video test pattern (colored squares)
// ============================================================================
module video_test_pattern_1
  import video_timing_signals_pkg::*;
(
    input  logic        pixel_clk,
    input  logic        pixel_rst_n,  // Synchronized to pixel_clk
    input  logic [ 1:0] res_sel,
    input  logic        hsync,
    input  logic        vsync,
    input  logic        de,           // Display Enable
    input  logic [11:0] pixel_x,
    input  logic [11:0] pixel_y,
    input  logic        frame_start,
    input  logic        line_start,
    output logic [23:0] rgb_data      // 3x8 bits
);
  localparam int COLSPC = 8;
  logic [COLSPC-1:0] SX = pixel_x[COLSPC-1:0];
  logic [COLSPC-1:0] SY = pixel_y[COLSPC-1:0];
  logic [COLSPC-1:0] W = {COLSPC{SX[7:0] == SY[7:0]}};
  logic [COLSPC-1:0] A = {COLSPC{SX[7:5] == 3'h2 && SY[7:5] == 3'h2}};

  logic [COLSPC-1:0] red;
  logic [COLSPC-1:0] green;
  logic [COLSPC-1:0] blue;
  always_ff @(posedge pixel_clk) begin
    red   <= ({SX[5:0] & {6{SY[4:3] == ~SX[4:3]}}, 4'b0} | W) & ~A;
    green <= (SX & {COLSPC{SY[6]}} | W) & ~A;
    blue  <= SY | W | A;
  end

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      rgb_data <= 24'h000000;
    end else begin
      rgb_data <= de ? {red, green, blue} : 24'h000000;
    end
  end

endmodule
