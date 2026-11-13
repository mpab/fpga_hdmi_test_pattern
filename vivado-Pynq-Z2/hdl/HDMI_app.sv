`timescale 1ns / 1ps

module HDMI_app #(
    COORDSPC   = 16,  // coordinate space (bits)
    COLSPC     = 10,  // color space (bits)
    MUL_TMDS,
    DIV_TMDS,
    DIV_PIXL,
    IN_CLK_PER
) (
    input  wire        sysclk,         // 50.00Mhz, 52.97619Mhz, ...
    input  wire        sys_reset_n,
    input  logic [2:0] res_sel,
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic       hdmi_tx_clk_p,
    output logic       hdmi_tx_clk_n
);
  logic pixel_clk, tmds_clk, video_enable, v_sync, h_sync, frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;
  logic [  COLSPC-1:0] red;
  logic [  COLSPC-1:0] green;
  logic [  COLSPC-1:0] blue;

  // produce pixel_clk & tmds_clk from sysclk
  HDMI_sig_gen #(
      .MUL_TMDS  (MUL_TMDS),
      .DIV_TMDS  (DIV_TMDS),
      .DIV_PIXL  (DIV_PIXL),
      .IN_CLK_PER(IN_CLK_PER)
  ) sig_gen (
      .*
  );
  // encode rgb & frame/line info
  HDMI_encoder encoder (.*);

  logic signals_valid, beam_at_zero, h_blank, v_blank;  // unused in this application
  VIDEO_timing_signals video_signals (.*);
  VIDEO_source source (.*);

endmodule  // top_HDMI
