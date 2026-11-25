`timescale 1ns / 1ps

module test (
    input  logic       pixel_clk,
    input  logic       pixel_rst_n,
    input  logic [1:0] res_sel,
    input  logic [1:0] pattern_sel,
    output logic       h_sync,
    output logic       v_sync,
    output logic       h_blank,
    output logic       v_blank,
    output logic       de,
    output logic [globals_pkg::COORD_BITS-1:0] beam_x,
    output logic [globals_pkg::COORD_BITS-1:0] beam_y,
    output logic       beam_at_zero,
    output logic       frame_start,
    output logic       line_start,
    output logic [3*globals_pkg::COLOR_BITS-1:0] rgb_data
);
  import globals_pkg::*;

  video_timing_signals_registered vts (.*);
  video_source vs (.*);
endmodule
