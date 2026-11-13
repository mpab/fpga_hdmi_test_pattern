`timescale 1ns / 1ps

`include "VIDEO_timing_signals_presets.vh"

module top_HDMI (
    input wire sys_100M_clk,
    input wire sys_reset_n,
    input wire sys_80_00_clk,  // 80.00 Mhz     -  800x600@60Hz 1/20/200 .IN_CLK_PER(25.0)
    input wire sys_74_28_clk,  // 74.28571 Mhz  - 1280x720@60Hz .IN_CLK_PER(13.461539)
    input wire sys_65_00_clk,  // 65.00 Mhz     - 1024x768@60Hz .IN_CLK_PER(15.3846)
    input wire sysclk_locked,
    input wire [1:0] res_sel,
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic hdmi_tx_clk_p,
    output logic hdmi_tx_clk_n
);
  logic _80_00_clk;
  //logic _74_28_clk;
  logic _65_00_clk;
  assign sys_80_00_clk = _80_00_clk;
  //assign sys_74_28_clk = _74_28_clk;
  assign sys_65_00_clk = _65_00_clk;

  // HDMI_app #(
  //     .H_RES(800),
  //     .H_FRONT_PORCH(40),
  //     .H_SYNC_PULSE(128),
  //     .H_BACK_PORCH(88),
  //     .H_SYNC_POL(1),
  //     .V_RES(600),
  //     .V_FRONT_PORCH(1),
  //     .V_SYNC_PULSE(4),
  //     .V_BACK_PORCH(23),
  //     .V_SYNC_POL(1),
  //     .MUL_TMDS(10),    //  80MHz x 10    = 800MHz
  //     .DIV_TMDS(2),     // 800MHz / 2     = 400MHz
  //     .DIV_PIXL(20),    // 800MHz / 20    = 40MHz
  //     .IN_CLK_PER(12.5) //      1 / 80MHz = 12.5ns
  // ) _600p (
  //     .sysclk(sys_80_00_clk),
  //     .hdmi_tx_d_p(hdmi_tx_d_p),
  //     .hdmi_tx_d_n(hdmi_tx_d_n),
  //     .hdmi_tx_clk_p(hdmi_tx_clk_p),
  //     .hdmi_tx_clk_n(hdmi_tx_clk_n)
  // );

  HDMI_app #(
      .MUL_TMDS  (10),        //  74.28571MHz x 10         = 742.8571MHz
      .DIV_TMDS  (1),         // 742.8571MHz / 1           = 742.8571MHz
      .DIV_PIXL  (10),        // 742.8571MHz / 10          = 74.28571MHz
      .IN_CLK_PER(13.461539)  //           1 / 74.28571MHz = 13.461539ns
  ) _720p (
      .sysclk(sys_74_28_clk),
      .sys_reset_n(sys_reset_n),
      .res_sel(res_sel),
      .hdmi_tx_d_p(hdmi_tx_d_p),
      .hdmi_tx_d_n(hdmi_tx_d_n),
      .hdmi_tx_clk_p(hdmi_tx_clk_p),
      .hdmi_tx_clk_n(hdmi_tx_clk_n)
  );

  // HDMI_app #(
  //     .H_RES        (1024),
  //     .H_FRONT_PORCH(24),
  //     .H_SYNC_PULSE (136),
  //     .H_BACK_PORCH (160),
  //     .H_SYNC_POL   (0),
  //     .V_RES        (768),
  //     .V_FRONT_PORCH(5),
  //     .V_SYNC_PULSE (5),
  //     .V_BACK_PORCH (20),
  //     .V_SYNC_POL   (0),
  //     .MUL_TMDS     (10),        //  65.0MHz x 10      = 650.0MHz
  //     .DIV_TMDS     (1),         // 650.0MHz / 1       = 650.0MHz
  //     .DIV_PIXL     (10),        // 650.0MHz / 10      = 65.0MHz
  //     .IN_CLK_PER   (15.384615)  //        1 / 65.0MHz = 15.384615ns
  // ) _768p (
  //     .sysclk(sys_65_00_clk),
  //     .hdmi_tx_d_p(hdmi_tx_d_p),
  //     .hdmi_tx_d_n(hdmi_tx_d_n),
  //     .hdmi_tx_clk_p(hdmi_tx_clk_p),
  //     .hdmi_tx_clk_n(hdmi_tx_clk_n)
  // );

endmodule  // top_HDMI
