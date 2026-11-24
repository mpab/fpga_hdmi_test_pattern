`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_signals_registered.sv
// Description: Multi-resolution VESA/CEA video timing signals generator.
// ============================================================================
module video_timing_signals_registered (
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
  import video_timing_pkg::*;

  video_timing_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);

  // update pixel position counters and emit registered signals
  logic [globals_pkg::COORD_BITS-1:0] hc, vc;
  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      hc <= 0;
      vc <= 0;
      beam_x <= 0;
      beam_y <= 0;
      de <= 0;
      frame_start <= 0;
      line_start <= 0;
      // reset is active, counters are at zero
      // and beam_at_zero is true
      beam_at_zero <= 1;
      h_blank <= 0;
      v_blank <= 0;
      h_sync <= cfg.h_pol ? 0 : 1;
      v_sync <= cfg.v_pol ? 0 : 1;
    end else begin
      // emit the signal for the current clock position
      de <= (hc < cfg.h_res) && (vc < cfg.v_res);
      frame_start <= (vc == cfg.v_total - 1) && (hc == cfg.h_total - 1);
      line_start <= (hc == cfg.h_total - 1);
      beam_at_zero <= (hc == 0) && (vc == 0);
      h_blank <= hc < cfg.h_res ? 0 : 1;  // unsigned, no need for lower bounds-check
      v_blank <= vc < cfg.v_res ? 0 : 1;
      h_sync <= (hc >= (cfg.h_res + cfg.h_fp)) &&
                (hc < (cfg.h_res + cfg.h_fp + cfg.h_sync)) ?
                cfg.h_pol : !cfg.h_pol;
      v_sync <= (vc >= (cfg.v_res + cfg.v_fp)) &&
                (vc < (cfg.v_res + cfg.v_fp + cfg.v_sync)) ?
                cfg.v_pol : !cfg.v_pol;
      beam_x <= hc;
      beam_y <= vc;

      // advance to the next beam position
      if (hc >= cfg.h_total - 1) begin
        hc <= 0;
        vc <= (vc >= cfg.v_total - 1) ? 0 : vc + 1;
      end else begin
        hc <= hc + 1;
      end
    end
  end

endmodule
