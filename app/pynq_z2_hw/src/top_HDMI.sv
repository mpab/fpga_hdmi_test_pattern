`timescale 1ns / 1ps

module top_HDMI #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10   // color space (bits)
) (
    input wire sysclk,  // 125MHz
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic hdmi_tx_clk_p,
    output logic hdmi_tx_clk_n
);
  logic clk, video_clk_tmds, video_enable, v_sync, h_sync, frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;
  logic [  COLSPC-1:0] red;
  logic [  COLSPC-1:0] green;
  logic [  COLSPC-1:0] blue;
  
  HDMI_sig_gen sig_gen (.*);
  HDMI_encoder encoder (.*);
  
  // TODO: connect reset
  logic reset, signals_valid, beam_at_zero, h_blank, v_blank;  // unused in this application
  VIDEO_timing_signals video_signals (.*);
  VIDEO_source source (.*);

endmodule  // top_HDMI
