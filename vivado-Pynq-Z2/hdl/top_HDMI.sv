`timescale 1ns / 1ps

`include "VIDEO_timing_signals_presets.vh"

module top_HDMI #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10   // color space (bits)
) (
    input  wire        sys_100M_clk,
    input  wire        sys_reset_n,
    input  wire        sys_80_00_clk,  // 80.00 Mhz     -  800x600@60Hz 1/20/200 .IN_CLK_PER(25.0)
    input  wire        sys_74_28_clk,  // 74.28571 Mhz  - 1280x720@60Hz .IN_CLK_PER(13.461539)
    input  wire        sys_65_00_clk,  // 65.00 Mhz     - 1024x768@60Hz .IN_CLK_PER(15.3846)
    input  wire        sysclk_locked,
    input  logic [2:0] res_sel,
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic       hdmi_tx_clk_p,
    output logic       hdmi_tx_clk_n
);
  // Create pixel and tmds clocks, and multiplex them.
  // This is a hack, and only works as the signals
  // are routed inside this module...
  // TODO: Implement a better dynamic HDMI clock solution
  logic pixel_600p_clk, tmds_600p_clk;
  HDMI_clk_gen #(
      .MUL_TMDS  (10),   //  80MHz x 10    = 800MHz
      .DIV_TMDS  (2),    // 800MHz / 2     = 400MHz
      .DIV_PIXL  (20),   // 800MHz / 20    = 40MHz
      .IN_CLK_PER(12.5)  //      1 / 80MHz = 12.5ns
  ) clk_600p (
      .sysclk(sys_80_00_clk),
      .pixel_clk(pixel_600p_clk),
      .tmds_clk(tmds_600p_clk)
  );

  logic pixel_720p_clk, tmds_720p_clk;
  HDMI_clk_gen #(
      .MUL_TMDS  (10),        //  74.28571MHz x 10         = 742.8571MHz
      .DIV_TMDS  (1),         // 742.8571MHz / 1           = 742.8571MHz
      .DIV_PIXL  (10),        // 742.8571MHz / 10          = 74.28571MHz
      .IN_CLK_PER(13.461539)  //           1 / 74.28571MHz = 13.461539ns
  ) clk_720p (
      .sysclk(sys_74_28_clk),
      .pixel_clk(pixel_720p_clk),
      .tmds_clk(tmds_720p_clk)
  );

  logic pixel_768p_clk, tmds_768p_clk;
  HDMI_clk_gen #(
      .MUL_TMDS  (10),        //  65.0MHz x 10      = 650.0MHz
      .DIV_TMDS  (1),         // 650.0MHz / 1       = 650.0MHz
      .DIV_PIXL  (10),        // 650.0MHz / 10      = 65.0MHz
      .IN_CLK_PER(15.384615)  //        1 / 65.0MHz = 15.384615ns
  ) clk_768p (
      .sysclk(sys_65_00_clk),
      .pixel_clk(pixel_768p_clk),
      .tmds_clk(tmds_768p_clk)
  );

  logic pixel_clk, tmds_clk;
  always_comb begin
    case (res_sel)
      RES_640x480:  /* NOP */;
      RES_800x600: begin
        pixel_clk = pixel_600p_clk;
        tmds_clk  = tmds_600p_clk;
      end
      RES_1280x720: begin
        pixel_clk = pixel_720p_clk;
        tmds_clk  = tmds_720p_clk;
      end
      RES_1024x768: begin
        pixel_clk = pixel_768p_clk;
        tmds_clk  = tmds_768p_clk;
      end
      default: begin
        pixel_clk = pixel_720p_clk;
        tmds_clk  = tmds_720p_clk;
      end
    endcase
  end

  logic video_enable, v_sync, h_sync, frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;
  logic [  COLSPC-1:0] red;
  logic [  COLSPC-1:0] green;
  logic [  COLSPC-1:0] blue;

  // encode rgb & frame/line info
  HDMI_encoder encoder (.*);

  logic signals_valid, beam_at_zero, h_blank, v_blank;  // unused in this application
  VIDEO_timing_signals video_signals (.*);
  VIDEO_source source (.*);

endmodule  // top_HDMI
