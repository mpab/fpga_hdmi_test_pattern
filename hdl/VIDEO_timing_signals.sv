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

  logic [globals_pkg::COORD_BITS-1:0] h_cnt, v_cnt;
  assign frame_start = (v_cnt == v_total - 1) && (h_cnt == h_total - 1);
  assign line_start = (h_cnt == h_total - 1);
  assign beam_at_zero = (h_cnt == 0) && (v_cnt == 0);
  assign h_blank = h_cnt < cfg.h_res ? 0 : 1;  // unsigned, no need for lower bounds-check
  assign v_blank = v_cnt < cfg.v_res ? 0 : 1;

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      h_cnt <= 0;
      v_cnt <= 0;
    end else begin
      if (h_cnt >= h_total - 1) begin
        h_cnt <= 0;
        if (v_cnt >= v_total - 1) v_cnt <= 0;
        else v_cnt <= v_cnt + 1;
      end else begin
        h_cnt <= h_cnt + 1;
      end
    end
  end

  // Registered timing outputs (avoids combinational glitches into TMDS encoder)
  logic hsync_raw, vsync_raw, de_raw;
  always_comb begin
    de_raw = (h_cnt < cfg.h_res) && (v_cnt < cfg.v_res);
    hsync_raw = (h_cnt >= (cfg.h_res + cfg.h_fp)) && (h_cnt < (cfg.h_res + cfg.h_fp + cfg.h_sync));
    vsync_raw = (v_cnt >= (cfg.v_res + cfg.v_fp)) && (v_cnt < (cfg.v_res + cfg.v_fp + cfg.v_sync));
  end

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      h_sync <= 1'b0;
      v_sync <= 1'b0;
      de     <= 1'b0;
      beam_x <= 0;
      beam_y <= 0;
    end else begin
      h_sync <= cfg.h_pol ? hsync_raw : ~hsync_raw;
      v_sync <= cfg.v_pol ? vsync_raw : ~vsync_raw;
      de     <= de_raw;
      beam_x <= h_cnt;
      beam_y <= v_cnt;
    end
  end

endmodule
