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
    input  wire         pixel_clk,
    input  wire         pixel_rst_n,  // Synchronized to pixel_clk
    output logic        hsync,
    output logic        vsync,
    output logic        de,           // Display Enable
    output logic [11:0] pixel_x,
    output logic [11:0] pixel_y,
    output logic        frame_start,
    output logic        line_start,
    output logic [23:0] rgb_data,     // 3x8 bits

    // customizations
    output logic [11:0] h_res,
    output logic [11:0] v_res,
    output logic [ 7:0] red,
    output logic [ 7:0] green,
    output logic [ 7:0] blue
);
  import globals_pkg::*;
  import video_timing_signals_pkg::*;

  // one-hot button/LED patterns
  localparam BOFF = 4'b0000;
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
      btn_latch <= B0;  // pixel_rst_n == 0: default pattern
      res_sel   <= globals_pkg::RES_DEFAULT;
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

  video_timing_signals_pkg::video_timing_t cfg;
  video_timing_signals timing_signals (.*);
  assign cfg   = get_video_timing(res_sel);
  assign red   = rgb_data[23:16];
  assign green = rgb_data[15:8];
  assign blue  = rgb_data[7:0];

  assign h_res = cfg.h_active;
  assign v_res = cfg.v_active;

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

  assign rgb_data = sw[0] ? tp1_rgb : tp0_rgb;

endmodule
