/**
* hdmi overlay demo
*/

module mycore #(
    parameter COORDSPC = 16,
    parameter COLSPC   = 10
) (
    input clk,
    input reset,

    input scandouble,

    output reg ce_pix,
    output     beam_at_zero,

    output reg HBlank,
    output reg HSync,
    output reg VBlank,
    output reg VSync,

    output [COLSPC-1:0] red,
    output [COLSPC-1:0] green,
    output [COLSPC-1:0] blue
);

  logic video_enable, frame_start, line_start;
  logic [COORDSPC-1:0] beam_x;
  logic [COORDSPC-1:0] beam_y;

  VIDEO_timing_signals video_signals (
      .clk(clk),
      .reset(reset),
      .signals_valid(ce_pix),
      .video_enable(video_enable),
      .beam_at_zero(beam_at_zero),
      .h_sync(HSync),
      .v_sync(VSync),
      .h_blank(HBlank),
      .v_blank(VBlank),
      .frame_start(frame_start),
      .line_start(line_start),
      .beam_x(beam_x),
      .beam_y(beam_y)
  );

  VIDEO_source video_source (
      .clk(clk),
      .video_enable(video_enable),
      .h_sync(HSync),
      .v_sync(VSync),
      .frame_start(frame_start),
      .line_start(line_start),
      .beam_x(beam_x),
      .beam_y(beam_y),
      .red(red),
      .green(green),
      .blue(blue)
  );

endmodule
