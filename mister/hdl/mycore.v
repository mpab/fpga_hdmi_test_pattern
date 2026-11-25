`timescale 1ns / 1ps

/**
* adapter to application rtl
*/

module mycore (
    input clk,
    input reset,

    input pal,
    input scandouble,
    input [1:0] buttons,

    output reg ce_pix,
    output     hvcnt_atzero,

    output reg HBlank,
    output reg HSync,
    output reg VBlank,
    output reg VSync,

    output reg [3*COLOR_BITS-1:0] rgb_data  // 3x8 bits rgb = 24 bit color
);
  import globals_pkg::*;
  import video_timing_pkg::*;

  logic de, frame_start, line_start;
  logic [globals_pkg::COORD_BITS-1:0] beam_x;
  logic [globals_pkg::COORD_BITS-1:0] beam_y;
  logic [1:0] res_sel;
  logic [1:0] pattern_sel;
  logic user_button;
  logic pixel_clk;
  assign user_button = buttons[1];
  // A real pixel clock signal: full sys-clock rate for forced scandoubler,
  // half rate otherwise. ce_pix remains the CE_PIXEL enable signal.
  assign pixel_clk = scandouble ? clk : ce_pix;

  // Advance the pixel clock even while reset is held.  The reset-release logic
  // in reference-top.sv depends on the zero beam signal from vts, which can
  // only be produced if pixel_clk is ticking during reset.
  always_ff @(posedge clk) begin
    if (reset) res_sel <= RES_1280x720_60;
    if (scandouble) ce_pix <= 1;
    else ce_pix <= ~ce_pix;
  end

  // cycle thru patterns
  always_ff @(posedge user_button) begin
    pattern_sel <= (pattern_sel == 3) ? 0 : pattern_sel + 1;
  end

  video_timing_signals_registered vts (
      .pixel_clk(pixel_clk),
      .pixel_rst_n(~reset),
      .res_sel(res_sel),
      .h_sync(HSync),
      .v_sync(VSync),
      .h_blank(HBlank),
      .v_blank(VBlank),
      .de(de),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .beam_at_zero(hvcnt_atzero),
      .frame_start(frame_start),
      .line_start(line_start)
  );

  // The source must be driven by the same pixel clock as the timing signal
  // generator; otherwise patterns advance on the system clock and are out
  // of phase with beam_x/beam_y (producing duplicated / shifted output).
  video_source vs (
      .pixel_clk(pixel_clk),
      .pixel_rst_n(~reset),
      .res_sel(res_sel),
      .pattern_sel(pattern_sel),
      .h_sync(HSync),
      .v_sync(VSync),
      .de(de),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .frame_start(frame_start),
      .line_start(line_start),
      .rgb_data(rgb_data)
  );

endmodule
