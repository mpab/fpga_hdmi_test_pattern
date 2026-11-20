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
  import video_timing_signals_pkg::*;

  logic de, frame_start, line_start;
  logic [globals_pkg::COORD_BITS-1:0] beam_x;
  logic [globals_pkg::COORD_BITS-1:0] beam_y;
  logic [1:0] res_sel;
  logic [1:0] pattern_sel;
  logic user_button;
  assign user_button = buttons[1];

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      res_sel <= RES_1280x720_60;
    end else begin
      if (scandouble) ce_pix <= 1;
      else ce_pix <= ~ce_pix;
    end
  end

  always_ff @(posedge user_button) begin
    pattern_sel <= pattern_sel ? 0 : 1;
  end

  video_timing_signals vts (
      .pixel_clk(ce_pix),
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

  video_source vs (
      .pixel_clk(clk),
      .pixel_rst_n(~reset),
      .res_sel(res_sel),
      .pattern_sel(pattern_sel),
      .h_sync(HSync),
      .v_sync(VSync),
      .de(ce_pix),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .frame_start(frame_start),
      .line_start(line_start),
      .rgb_data(rgb_data)
  );

endmodule
