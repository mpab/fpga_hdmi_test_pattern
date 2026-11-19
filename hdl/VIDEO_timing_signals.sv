`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_signals.sv
// Description: Multi-resolution VESA/CEA video timing signals generator.
// ============================================================================
module video_timing_signals (
    input  logic        pixel_clk,
    input  logic        pixel_rst_n,  // Synchronized to pixel_clk
    input  logic [ 1:0] res_sel,
    output logic        hsync,
    output logic        vsync,
    output logic        de,           // Active video Data Enable (Display Enable)
    output logic [11:0] pixel_x,
    output logic [11:0] pixel_y,
    output logic        frame_start,
    output logic        line_start
);
  import video_timing_signals_pkg::*;
  video_timing_signals_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  logic [11:0] h_total, v_total;
  assign h_total = cfg.h_active + cfg.h_fp + cfg.h_sync + cfg.h_bp;
  assign v_total = cfg.v_active + cfg.v_fp + cfg.v_sync + cfg.v_bp;

  // TODO: re-test this
  assign frame_start = (pixel_y == v_total - 1) && (pixel_x == h_total - 1);
  assign line_start = (pixel_x == h_total - 1);

  logic [11:0] h_cnt, v_cnt;

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      h_cnt <= 12'd0;
      v_cnt <= 12'd0;
    end else begin
      if (h_cnt >= h_total - 12'd1) begin
        h_cnt <= 12'd0;
        if (v_cnt >= v_total - 12'd1) v_cnt <= 12'd0;
        else v_cnt <= v_cnt + 12'd1;
      end else begin
        h_cnt <= h_cnt + 12'd1;
      end
    end
  end

  // Registered timing outputs (avoids combinational glitches into TMDS encoder)
  logic hsync_raw, vsync_raw, de_raw;
  always_comb begin
    de_raw = (h_cnt < cfg.h_active) && (v_cnt < cfg.v_active);
    hsync_raw = (h_cnt >= (cfg.h_active + cfg.h_fp)) &&
                    (h_cnt <  (cfg.h_active + cfg.h_fp + cfg.h_sync));
    vsync_raw = (v_cnt >= (cfg.v_active + cfg.v_fp)) &&
                    (v_cnt <  (cfg.v_active + cfg.v_fp + cfg.v_sync));
  end

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      hsync   <= 1'b0;
      vsync   <= 1'b0;
      de      <= 1'b0;
      pixel_x <= 12'd0;
      pixel_y <= 12'd0;
    end else begin
      hsync   <= cfg.h_pol ? hsync_raw : ~hsync_raw;
      vsync   <= cfg.v_pol ? vsync_raw : ~vsync_raw;
      de      <= de_raw;
      pixel_x <= h_cnt;
      pixel_y <= v_cnt;
    end
  end

endmodule
