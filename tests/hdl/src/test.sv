`timescale 1ns / 1ps

module test (
    input  logic pixel_clk,
    input  logic pixel_rst_n,
    input  logic [1:0] res_sel,
    output logic [globals_pkg::COORD_BITS-1:0] beam_x,
    output logic [globals_pkg::COORD_BITS-1:0] beam_y,
    output logic [3*globals_pkg::COLOR_BITS-1:0] rgb_data
);
  import globals_pkg::*;
  import video_timing_pkg::*;

  logic h_sync, v_sync, h_blank, v_blank, de, beam_at_zero, frame_start, line_start;
  video_timing_signals_registered vts (
      .pixel_clk(pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .res_sel(res_sel),
      .h_sync(h_sync),
      .v_sync(v_sync),
      .h_blank(h_blank),
      .v_blank(v_blank),
      .de(de),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .beam_at_zero(beam_at_zero),
      .frame_start(frame_start),
      .line_start(line_start)
  );

  video_source vs (
      .pixel_clk(pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .res_sel(res_sel),
      .pattern_sel(2'b11),
      .h_sync(h_sync),
      .v_sync(v_sync),
      .de(de),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .frame_start(frame_start),
      .line_start(line_start),
      .rgb_data(rgb_data)
  );
endmodule
