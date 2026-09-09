`timescale 1ns / 1ps

module top_HDMI_ (
    input wire sysclk,  // 125MHz
    input wire [0:0] hdmi_intn,
    output wire [15:0] hdmi_data, (* X_INTERFACE_PARAMETER = "FREQ_HZ 148500000" *)
    output wire hdmi_clk,
    output wire hdmi_de,
    output wire hdmi_vs,
    output wire hdmi_hs
);
  top_HDMI hdmi (
      .sysclk(sysclk),
      .hdmi_intn(hdmi_intn),
      .hdmi_data(hdmi_data),
      .hdmi_clk(hdmi_clk),
      .hdmi_de(hdmi_de),
      .hdmi_vs(hdmi_vs),
      .hdmi_hs(hdmi_hs)
  );
endmodule  // top_HDMI_
