`timescale 1ns / 1ps

module top_HDMI #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10   // color space (bits)
) (
    input wire sysclk,  // 125MHz
    input wire [0:0] hdmi_intn, // what is this?
    output logic [15:0] hdmi_data,
    output logic hdmi_clk,
    output logic hdmi_de,
    output logic hdmi_vs,
    output logic hdmi_hs
);
  // internal signals
  logic frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;
  logic [  COLSPC-1:0] red;
  logic [  COLSPC-1:0] green;
  logic [  COLSPC-1:0] blue;
  
  // VIDEO_timing_signals unused in this application
  logic reset, signals_valid, beam_at_zero, v_blank, h_blank;

  // compose components
  VIDEO_source source (
      .clk(sysclk),
      .video_enable(hdmi_de),
      .v_sync(hdmi_vs),
      .h_sync(hdmi_hs),
      .* // internal signals
  );

  VIDEO_timing_signals video_signals (
      .clk(sysclk),
      .video_enable(hdmi_de),
      .v_sync(hdmi_vs),
      .h_sync(hdmi_hs),
      .* // internal signals
  );

  // map external signals 
  assign hdmi_clk = sysclk;
  assign hdmi_data[15:11] = red[COLSPC-1:COLSPC-6];  // 5 bits red
  assign hdmi_data[10:5] = green[COLSPC-1:COLSPC-7];  // 6 bits green
  assign hdmi_data[4:0] = blue[COLSPC-1:COLSPC-6];  // 5 bits blue

endmodule  // top_HDMI
