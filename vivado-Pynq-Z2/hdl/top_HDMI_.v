`timescale 1ns / 1ps

module top_HDMI_ #(
) (
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 80000000" *)
    input wire sys_80_00_clk,  // 80.00 Mhz     -  800x600@60Hz 1/20/200 .IN_CLK_PER(25.0)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 74285714" *)
    input wire sys_74_28_clk,  // 74.28571 Mhz  - 1280x720@60Hz .IN_CLK_PER(13.461539)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 65000000" *)
    input wire sys_65_00_clk,  // 65.00 Mhz     - 1024x768@60Hz .IN_CLK_PER(15.3846)
    input wire sysclk_locked,
    output wire [2:0] hdmi_tx_d_p,
    output wire [2:0] hdmi_tx_d_n, (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *)
    output wire hdmi_tx_clk_p, (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *)
    output wire hdmi_tx_clk_n,
    input wire[3:0] btn,
    output wire [3:0] led
);
  top_HDMI hdmi (
      .sys_80_00_clk(sys_80_00_clk),
      .sys_74_28_clk(sys_74_28_clk),
      .sys_65_00_clk(sys_65_00_clk),
      .sysclk_locked(sysclk_locked),
      .hdmi_tx_d_p(hdmi_tx_d_p),
      .hdmi_tx_d_n(hdmi_tx_d_n),
      .hdmi_tx_clk_p(hdmi_tx_clk_p),
      .hdmi_tx_clk_n(hdmi_tx_clk_n),
      .btn(btn),
      .led(led)
  );
endmodule  // top_HDMI_
