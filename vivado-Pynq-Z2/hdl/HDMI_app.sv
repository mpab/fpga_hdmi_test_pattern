`timescale 1ns / 1ps

module HDMI_app #(
    COORDSPC      = 16,  // coordinate space (bits)
    COLSPC        = 10,  // color space (bits)
    H_RES,
    H_FRONT_PORCH,
    H_SYNC_PULSE,
    H_BACK_PORCH,
    H_SYNC_POL,
    V_RES,
    V_FRONT_PORCH,
    V_SYNC_PULSE,
    V_BACK_PORCH,
    V_SYNC_POL,
    MUL_TMDS,
    DIV_TMDS,
    DIV_PIXL,
    IN_CLK_PER
) (
    input  wire        sysclk,         // 50.00Mhz, 52.97619Mhz, ...
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic       hdmi_tx_clk_p,
    output logic       hdmi_tx_clk_n
);
  logic clk, video_clk_tmds, video_enable, v_sync, h_sync, frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;
  logic [  COLSPC-1:0] red;
  logic [  COLSPC-1:0] green;
  logic [  COLSPC-1:0] blue;

  // produce clk & video_clk_tmds from sysclk
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

  // TODO: connect reset
  logic reset, signals_valid, beam_at_zero, h_blank, v_blank;  // unused in this application
  VIDEO_timing_signals #(
      .H_RES(H_RES),
      .H_FRONT_PORCH(H_FRONT_PORCH),
      .H_SYNC_PULSE(H_SYNC_PULSE),
      .H_BACK_PORCH(H_BACK_PORCH),
      .H_SYNC_POL(H_SYNC_POL),
      .V_RES(V_RES),
      .V_FRONT_PORCH(V_FRONT_PORCH),
      .V_SYNC_PULSE(V_SYNC_PULSE),
      .V_BACK_PORCH(V_BACK_PORCH),
      .V_SYNC_POL(V_SYNC_POL)
  ) video_signals (
      .*
  );
  VIDEO_source source (.*);

endmodule  // top_HDMI
