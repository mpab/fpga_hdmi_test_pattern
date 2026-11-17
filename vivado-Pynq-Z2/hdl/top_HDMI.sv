// ============================================================================
// File: top_hdmi.sv
// Description: End-to-end HDMI TX design for TUL PYNQ-Z2.
//              - Programmable MMCM generates dynamic PixelClk & 5x TmdsClk
//              - Multi-mode timing & test image generator
//              - 3x TMDS 8b/10b encoders + 4x 10:1 DDR OSERDESE2/OBUFDS channels
// ============================================================================
module top_hdmi (
    input  logic       sys_clk,        // 125 MHz board clock (H16)
    input  logic       sys_rst_n,
    input  logic [1:0] res_sel,        // 2-bit resolution selector (0..3 valid modes)
    input  logic [1:0] pattern_sel,    // video test card pattern
    output logic       clk_locked,
    output logic       hdmi_tx_clk_p,
    output logic       hdmi_tx_clk_n,
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n
);
  // Programmable Base & Derived Clocks
  logic pixel_clk, tmds_clk;

  hdmi_clk_gen u_clk_gen (
      .sys_clk_125m(sys_clk),
      .sys_rst_n   (sys_rst_n),
      .res_sel     (res_sel),
      .pixel_clk   (pixel_clk),
      .tmds_clk    (tmds_clk),
      .clk_locked  (clk_locked)
  );

  // Synchronous Reset Bridge into pixel_clk domain (CRITICAL for OSERDESE2)
  logic [2:0] rst_sync_chain;
  logic       pixel_rst_n;
  logic       serdes_rst;

  always_ff @(posedge pixel_clk or negedge clk_locked) begin
    if (!clk_locked) rst_sync_chain <= 3'b000;
    else rst_sync_chain <= {rst_sync_chain[1:0], 1'b1};
  end

  assign pixel_rst_n = rst_sync_chain[2];
  assign serdes_rst  = ~rst_sync_chain[2];  // Active-high synchronous release

  // Video Timing
  logic hsync, vsync, de;
  logic [11:0] pixel_x, pixel_y;
  logic [23:0] rgb_data;

  video_timing_signals u_timing_signals (
      .pixel_clk  (pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .res_sel    (res_sel),
      .hsync      (hsync),
      .vsync      (vsync),
      .de         (de),
      .pixel_x    (pixel_x),
      .pixel_y    (pixel_y)
  );

  // Pattern Generator(s)
  logic frame_start, line_start;  // unused
  video_source vs (.*);

  // 4. Three Parallel RGB 8b/10b TMDS Encoders
  logic [9:0] tmds_red, tmds_green, tmds_blue;

  // Channel 0 (Blue) carries HSYNC/VSYNC during blanking (DVI 1.0 Sec 3.1.2)
  tmds_encoder u_enc_blue (
      .pixel_clk  (pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .vd         (rgb_data[7:0]),
      .cd         ({vsync, hsync}),
      .vde        (de),
      .tmds_out   (tmds_blue)
  );

  // Channel 1 (Green) carries CTL[1:0] = 2'b00 during blanking
  tmds_encoder u_enc_green (
      .pixel_clk  (pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .vd         (rgb_data[15:8]),
      .cd         (2'b00),
      .vde        (de),
      .tmds_out   (tmds_green)
  );

  // Channel 2 (Red) carries CTL[3:2] = 2'b00 during blanking
  tmds_encoder u_enc_red (
      .pixel_clk  (pixel_clk),
      .pixel_rst_n(pixel_rst_n),
      .vd         (rgb_data[23:16]),
      .cd         (2'b00),
      .vde        (de),
      .tmds_out   (tmds_red)
  );

  // Four 10:1 DDR OSERDESE2 + OBUFDS Channels (Data[2:0] + Clock)
  tmds_oserdes_10to1 u_ser_blue (
      .pixel_clk (pixel_clk),
      .tmds_clk  (tmds_clk),
      .serdes_rst(serdes_rst),
      .tmds_data (tmds_blue),
      .tmds_p    (hdmi_tx_d_p[0]),
      .tmds_n    (hdmi_tx_d_n[0])
  );

  tmds_oserdes_10to1 u_ser_green (
      .pixel_clk (pixel_clk),
      .tmds_clk  (tmds_clk),
      .serdes_rst(serdes_rst),
      .tmds_data (tmds_green),
      .tmds_p    (hdmi_tx_d_p[1]),
      .tmds_n    (hdmi_tx_d_n[1])
  );

  tmds_oserdes_10to1 u_ser_red (
      .pixel_clk (pixel_clk),
      .tmds_clk  (tmds_clk),
      .serdes_rst(serdes_rst),
      .tmds_data (tmds_red),
      .tmds_p    (hdmi_tx_d_p[2]),
      .tmds_n    (hdmi_tx_d_n[2])
  );

  // Forward 1x Pixel Clock via identical OSERDESE2 path using 10'b00000_11111
  tmds_oserdes_10to1 u_ser_clk (
      .pixel_clk (pixel_clk),
      .tmds_clk  (tmds_clk),
      .serdes_rst(serdes_rst),
      .tmds_data (10'b00000_11111),
      .tmds_p    (hdmi_tx_clk_p),
      .tmds_n    (hdmi_tx_clk_n)
  );

endmodule
