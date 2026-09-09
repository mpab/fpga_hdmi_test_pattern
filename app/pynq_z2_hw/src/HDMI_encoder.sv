`timescale 1ns / 1ps

// (c) fpga4fun.com & KNJN LLC 2013
// edited/updated for vivado 2020.1 by Dominic Meads 10/2020
// refactored/updated for vivado 2023.x mpab

module HDMI_encoder #(
    COLSPC = 10  // color space (bits)
) (
    input wire clk,
    input wire video_clk_tmds,
    input wire video_enable,
    input wire v_sync,
    input wire h_sync,

    input wire [COLSPC-1:0] red,
    input wire [COLSPC-1:0] green,
    input wire [COLSPC-1:0] blue,

    // external (board) connections
    output logic [2:0] hdmi_tx_d_p,
    output logic [2:0] hdmi_tx_d_n,
    output logic hdmi_tx_clk_p,
    output logic hdmi_tx_clk_n
);

  ////////////////////////////////////////////////////////////////////////

  // 8b/10b encoding for transmission
  logic [COLSPC-1:0] tmds_red, tmds_green, tmds_blue;

  // instantiate TMDS encoders (TMDS_encoder.vhd file from github)
  TMDS_encoder encode_red (
      .clk (clk),
      .VD  (red),
      .CD  (2'b00),
      .VDE (video_enable),
      .TMDS(tmds_red)
  );
  TMDS_encoder encode_green (
      .clk (clk),
      .VD  (green),
      .CD  (2'b00),
      .VDE (video_enable),
      .TMDS(tmds_green)
  );
  TMDS_encoder encode_blue (
      .clk(clk),
      .VD(blue),
      .CD({v_sync, h_sync}),
      .VDE(video_enable),  // sync on blue
      .TMDS(tmds_blue)
  );
  // end 8b/10b encoding

  ////////////////////////////////////////////////////////////////////////
  // Serializer and output buffers
  logic [3:0] TMDS_mod10 = 0;  // modulus 10 counter
  logic [COLSPC-1:0] TMDS_shift_red = 0, TMDS_shift_green = 0, TMDS_shift_blue = 0;
  logic TMDS_shift_load = 0;

  always_ff @(posedge video_clk_tmds)
    TMDS_shift_load <= (TMDS_mod10 == 4'd9);  // shift load is high only if mod ten counter is done

  always_ff @(posedge video_clk_tmds) begin
    TMDS_shift_red   <= TMDS_shift_load ? tmds_red   : TMDS_shift_red  [9:1];  // only if all the old data has been serialized, then start shifting new data
    TMDS_shift_green <= TMDS_shift_load ? tmds_green : TMDS_shift_green[9:1];  // kind of a wierd way of shifting but it works. replacing the last shift data with the MSB:LSB+1
    TMDS_shift_blue <= TMDS_shift_load ? tmds_blue : TMDS_shift_blue[9:1];
    TMDS_mod10 <= (TMDS_mod10==4'd9) ? 4'd0 : TMDS_mod10+4'd1;                 // increase counter or reset after 10 counts
  end

  // instantiate differential output buffers
  // OBUFDS: Differential Output Buffer
  //         Artix-7
  // Xilinx HDL Language Template, version 2020.1

  OBUFDS #(
      .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
      .SLEW      ("SLOW")      // Specify the output slew rate
  ) OBUFDS_red (
      .O (hdmi_tx_d_p[2]),    // Diff_p output (connect directly to top-level port)
      .OB(hdmi_tx_d_n[2]),    // Diff_n output (connect directly to top-level port)
      .I (TMDS_shift_red[0])  // Buffer input
  );

  // End of OBUFDS_inst instantiation

  // OBUFDS: Differential Output Buffer
  //         Artix-7
  // Xilinx HDL Language Template, version 2020.1

  OBUFDS #(
      .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
      .SLEW      ("SLOW")      // Specify the output slew rate
  ) OBUFDS_green (
      .O (hdmi_tx_d_p[1]),      // Diff_p output (connect directly to top-level port)
      .OB(hdmi_tx_d_n[1]),      // Diff_n output (connect directly to top-level port)
      .I (TMDS_shift_green[0])  // Buffer input
  );

  // End of OBUFDS_inst instantiation

  // OBUFDS: Differential Output Buffer
  //         Artix-7
  // Xilinx HDL Language Template, version 2020.1

  OBUFDS #(
      .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
      .SLEW      ("SLOW")      // Specify the output slew rate
  ) OBUFDS_blue (
      .O (hdmi_tx_d_p[0]),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_tx_d_n[0]),     // Diff_n output (connect directly to top-level port)
      .I (TMDS_shift_blue[0])  // Buffer input
  );

  // End of OBUFDS_inst instantiation
  // OBUFDS: Differential Output Buffer
  //         Artix-7
  // Xilinx HDL Language Template, version 2020.1

  OBUFDS #(
      .IOSTANDARD("DEFAULT"),  // Specify the output I/O standard
      .SLEW      ("SLOW")      // Specify the output slew rate
  ) OBUFDS_clock (
      .O(hdmi_tx_clk_p),  // Diff_p output (connect directly to top-level port)
      .OB(hdmi_tx_clk_n),  // Diff_n output (connect directly to top-level port)
      .I(clk)  // Buffer input
  );

  // End of OBUFDS_inst instantiation
endmodule  // HDMI_encoder
