`timescale 1ns / 1ps

module top_HDMI_ #(
) (
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100000000" *)
    input wire sys_100M_clk,
    input wire sys_reset_n,
    // TODO: Implement a better dynamic HDMI clock solution
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
  reg [3:0] latch;
  assign led = latch;

  reg [1:0] res_sel;

  // crude debounce
  always @(posedge sys_100M_clk or negedge sys_reset_n) begin
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
  always @(posedge sys_100M_clk or negedge sys_reset_n) begin
    if (~sys_reset_n) begin
      latch   <= B2;  // sys_reset_n == 0: default pattern
      res_sel <= 2;
    end else begin
      // detect exactly one debounced button press and only react to changes
      if (btnq0 == btnq1 == btnq2 == btnq3) begin
        if ((btnq0 == B0) && (B0 != latch)) begin
          latch <= B0;
          // res_sel <= 0; don't change resolution, 480p NYI
        end else if ((btnq0 == B1) && (B1 != latch)) begin
          latch   <= B1;
          res_sel <= 1;
        end else if ((btnq0 == B2) && (B2 != latch)) begin
          latch   <= B2;
          res_sel <= 2;
        end else if ((btnq0 == B3) && (B3 != latch)) begin
          latch   <= B3;
          res_sel <= 3;
        end
      end
    end
  end

  top_HDMI hdmi (
      .sys_100M_clk(sys_100M_clk),
      .sys_reset_n(sys_reset_n),
      .sys_80_00_clk(sys_80_00_clk),
      .sys_74_28_clk(sys_74_28_clk),
      .sys_65_00_clk(sys_65_00_clk),
      .sysclk_locked(sysclk_locked),
      .res_sel(res_sel),
      .hdmi_tx_d_p(hdmi_tx_d_p),
      .hdmi_tx_d_n(hdmi_tx_d_n),
      .hdmi_tx_clk_p(hdmi_tx_clk_p),
      .hdmi_tx_clk_n(hdmi_tx_clk_n)
  );
endmodule  // top_HDMI_
