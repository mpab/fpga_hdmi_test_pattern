`timescale 1ns / 1ps
// ============================================================================
// File: video_source.sv
// Description: Wrapper for video source(s)
// ============================================================================
module video_source (
    input  logic        pixel_clk,
    input  logic        pixel_rst_n,  // Synchronized to pixel_clk
    input  logic [ 1:0] res_sel,
    input  logic [ 1:0] pattern_sel,
    input  logic        hsync,
    input  logic        vsync,
    input  logic        de,           // Display Enable
    input  logic [11:0] pixel_x,
    input  logic [11:0] pixel_y,
    input  logic        frame_start,
    input  logic        line_start,
    output logic [23:0] rgb_data      // 3x8 bits
);

  logic [23:0] tp0_rgb;
  video_test_pattern_0 tp0 (
      .*,
      .rgb_data(tp0_rgb)
  );
  logic [23:0] tp1_rgb;
  video_test_pattern_1 tp1 (
      .*,
      .rgb_data(tp1_rgb)
  );

  always_ff @(posedge pixel_clk) begin
    rgb_data <= pattern_sel[0] ? tp1_rgb : tp0_rgb;
  end

endmodule
