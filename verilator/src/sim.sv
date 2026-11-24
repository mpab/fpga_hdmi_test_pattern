`timescale 1ns / 1ps
// ============================================================================
// File: sim.sv
// Description: Proxy for video source(s)
// ============================================================================
module sim (
    // board I/O
    input  wire [1:0] sw,
    input  wire [3:0] btn,
    output wire [3:0] led,

    // standard video I/O
    input  wire                     pixel_clk,
    input  wire                     pixel_rst_n,  // synchronized to pixel_clk
    output logic                    h_sync,
    output logic                    v_sync,
    output logic                    de,           // display enable
    output logic [  COORD_BITS-1:0] beam_x,
    output logic [  COORD_BITS-1:0] beam_y,
    output logic                    frame_start,
    output logic                    line_start,
    output logic [3*COLOR_BITS-1:0] rgb_data,     // 3x8 bits rgb = 24 bit color

    // customizations
    output logic [COORD_BITS-1:0] h_res,
    output logic [COORD_BITS-1:0] v_res,
    output logic [COLOR_BITS-1:0] red,
    output logic [COLOR_BITS-1:0] green,
    output logic [COLOR_BITS-1:0] blue,

    output logic [COORD_BITS-1:0] h_total,
    output logic [COORD_BITS-1:0] v_total
);
  import globals_pkg::*;
  import video_timing_pkg::*;

  assign red   = rgb_data[3*COLOR_BITS-1:2*COLOR_BITS];
  assign green = rgb_data[2*COLOR_BITS-1:COLOR_BITS];
  assign blue  = rgb_data[COLOR_BITS-1:0];
  video_timing_pkg::video_timing_t cfg;
  assign cfg = get_video_timing(res_sel);
  assign h_res = cfg.h_res;
  assign v_res = cfg.v_res;
  assign h_total = cfg.h_total;
  assign v_total = cfg.v_total;

  // one-hot button/resolution select
  localparam B0   = 4'b0001;
  localparam B1   = 4'b0010;
  localparam B2   = 4'b0100;
  localparam B3   = 4'b1000;

  // last valid button press/current LED pattern
  reg [3:0] btn_latch;
  assign led = btn_latch;
  // one-hot to resolution selection
  logic [1:0] res_sel;
  // button press handler
  always @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (~pixel_rst_n) begin
      // NOTE: these should be in synch
      btn_latch <= B0;
      res_sel   <= 0;
    end else begin
      // detect exactly one debounced button press and only react to changes
      if ((btn == B0) && (B0 != btn_latch)) begin
        btn_latch <= B0;
        res_sel   <= 0;
      end else if ((btn == B1) && (B1 != btn_latch)) begin
        btn_latch <= B1;
        res_sel   <= 1;
      end else if ((btn == B2) && (B2 != btn_latch)) begin
        btn_latch <= B2;
        res_sel   <= 2;
      end else if ((btn == B3) && (B3 != btn_latch)) begin
        btn_latch <= B3;
        res_sel   <= 3;
      end
    end
  end

  logic h_blank, v_blank, beam_at_zero;
  video_timing_signals_registered vts (.*);

  video_source vs (
      .*,
      .pattern_sel(sw)
  );

endmodule
