`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_signals.sv
// Description: Multi-resolution VESA/CEA video timing signals generator.
// ============================================================================
module video_timing_signals (
    input  logic                               pixel_clk,
    input  logic                               pixel_rst_n,   // synchronized to pixel_clk
    input  logic [                        1:0] res_sel,
    output logic                               h_sync,
    output logic                               v_sync,
    output logic                               h_blank,
    output logic                               v_blank,
    output logic                               de,            // device enable
    output logic [globals_pkg::COORD_BITS-1:0] beam_x,
    output logic [globals_pkg::COORD_BITS-1:0] beam_y,
    output logic                               beam_at_zero,
    output logic                               frame_start,
    output logic                               line_start
);
  import globals_pkg::*;
  import video_timing_signals_pkg::*;

  video_timing_signals_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  logic [globals_pkg::COORD_BITS-1:0] h_total, v_total;
  assign h_total = cfg.h_res + cfg.h_fp + cfg.h_sync + cfg.h_bp;
  assign v_total = cfg.v_res + cfg.v_fp + cfg.v_sync + cfg.v_bp;

  assign frame_start = (beam_y == v_total - 1) && (beam_x == h_total - 1);
  assign line_start = (beam_x == h_total - 1);
  assign beam_at_zero = (beam_x == 0) && (beam_y == 0);
  assign h_blank = beam_x < cfg.h_res ? 0 : 1;  // unsigned, no need for lower bounds-check
  assign v_blank = beam_y < cfg.v_res ? 0 : 1;
  assign h_sync = (beam_x >= (cfg.h_res + cfg.h_fp)) &&
                (beam_x < (cfg.h_res + cfg.h_fp + cfg.h_sync)) ?
                cfg.h_pol : !cfg.h_pol;
  assign v_sync = (beam_y >= (cfg.v_res + cfg.v_fp)) &&
                (beam_y < (cfg.v_res + cfg.v_fp + cfg.v_sync)) ?
                cfg.v_pol : !cfg.v_pol;
  assign de = (beam_x < cfg.h_res) && (beam_y < cfg.v_res);

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      beam_x <= h_total;
      beam_y <= v_total;
    end else begin
      if (beam_x >= h_total - 1) begin
        beam_x <= 0;
        if (beam_y >= v_total - 1) beam_y <= 0;
        else beam_y <= beam_y + 1;
      end else begin
        beam_x <= beam_x + 1;
      end
    end
  end

endmodule
