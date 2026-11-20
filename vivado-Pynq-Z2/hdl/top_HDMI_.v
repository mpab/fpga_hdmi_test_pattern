`timescale 1ns / 1ps
// ============================================================================
// File: top_hdmi_.sv
// Description: Wraps/forwards to top_hdmi.sv
//              Converts button presses and switch inputs
// ============================================================================

// TODO
// change test pattern with switches
// RGB LEDs reflect status

module top_hdmi_ (
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 125000000" *)
    input wire sys_clk,
    input wire sys_reset_n,
    output wire [2:0] hdmi_tx_d_p,
    output wire [2:0] hdmi_tx_d_n,
    //
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *)
    output wire hdmi_tx_clk_p,
    //
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *)
    output wire hdmi_tx_clk_n,
    input wire [1:0] sw,
    input wire [3:0] btn,
    output wire [3:0] led
);
  // one-hot button/LED patterns
  localparam BOFF = 4'b0000;
  localparam B0   = 4'b0001;
  localparam B1   = 4'b0010;
  localparam B2   = 4'b0100;
  localparam B3   = 4'b1000;

  // debounce 'queue'
  reg [3:0] btnq0;
  reg [3:0] btnq1;
  reg [3:0] btnq2;
  reg [3:0] btnq3;

  // last valid button press/current LED pattern
  reg [3:0] btn_latch;
  assign led = btn_latch;

  reg [1:0] res_sel;

  // crude debounce
  always @(posedge sys_clk or negedge sys_reset_n) begin
    if (~sys_reset_n) begin
      btnq0 <= BOFF;
      btnq1 <= BOFF;
      btnq2 <= BOFF;
      btnq3 <= BOFF;
    end else begin
      btnq0 <= btnq1;
      btnq1 <= btnq2;
      btnq2 <= btnq3;
      btnq3 <= btn;
    end
  end

  // button press handler
  always @(posedge sys_clk or negedge sys_reset_n) begin
    if (~sys_reset_n) begin
      btn_latch <= B2;  // sys_reset_n == 0: default pattern
      res_sel   <= 2;
    end else begin
      // detect exactly one debounced button press and only react to changes
      if (btnq0 == btnq1 == btnq2 == btnq3) begin
        if ((btnq0 == B0) && (B0 != btn_latch)) begin
          btn_latch <= B0;
          res_sel   <= 0;
        end else if ((btnq0 == B1) && (B1 != btn_latch)) begin
          btn_latch <= B1;
          res_sel   <= 1;
        end else if ((btnq0 == B2) && (B2 != btn_latch)) begin
          btn_latch <= B2;
          res_sel   <= 2;
        end else if ((btnq0 == B3) && (B3 != btn_latch)) begin
          btn_latch <= B3;
          res_sel   <= 3;
        end
      end
    end
  end

  reg clk_locked;  // will be used for RGB LED feature
  top_hdmi hdmi (
      .sys_clk(sys_clk),
      .sys_rst_n(sys_reset_n),
      .res_sel(res_sel),
      .pattern_sel(sw),
      .hdmi_tx_d_p(hdmi_tx_d_p),
      .hdmi_tx_d_n(hdmi_tx_d_n),
      .hdmi_tx_clk_p(hdmi_tx_clk_p),
      .hdmi_tx_clk_n(hdmi_tx_clk_n)
  );
endmodule  // top_hdmi_
