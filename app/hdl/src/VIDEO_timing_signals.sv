`timescale 1ns / 1ps

// references:
// https://vanhunteradams.com/DE1/VGA_Driver/Driver.html
// https://adaptivesupport.amd.com/s/article/899769?language=en_US

module VIDEO_timing_signals #(
    parameter H_RES         = 640,  // drawable columns
    parameter H_FRONT_PORCH = 16,   // horizontal front porch
    parameter H_SYNC_PULSE  = 96,   // horizontal sync
    parameter H_BACK_PORCH  = 48,   // horizontal back porch
    parameter H_SYNC_POL    = 0,    // horizontal sync polarity (0:neg, 1:pos)

    parameter V_RES         = 480,  // drawable rows
    parameter V_FRONT_PORCH = 10,   // vertical front porch
    parameter V_SYNC_PULSE  = 2,    // vertical sync
    parameter V_BACK_PORCH  = 33,   // vertical back porch
    parameter V_SYNC_POL    = 0,    // vertical sync polarity (0:neg, 1:pos)

    parameter COORDSPC = 16  // coordinate space (bits)
) (
    input  wire                        clk,
    input  wire                        reset,
    // input                           scandouble,
    output logic                       signals_valid,
    output logic                       video_enable,
    output logic                       beam_at_zero,
    output logic                       h_sync,
    output logic                       v_sync,
    output logic                       h_blank,
    output logic                       v_blank,
    output logic                       frame_start,
    output logic                       line_start,
    output logic signed [COORDSPC-1:0] beam_x,
    output logic signed [COORDSPC-1:0] beam_y
);

  localparam H_SIG_LEN = H_RES + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
  localparam V_SIG_LEN = V_RES + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
  localparam H_SIG_END = H_SIG_LEN - 1;  // signal end
  localparam V_SIG_END = V_SIG_LEN - 1;  // signal end
  // -ve co-ordinate wrap-around
  localparam signed H_DRAW_END = H_RES - 1;
  localparam signed H_NEG_START = 0 - (H_SIG_LEN - H_RES);
  localparam signed V_DRAW_END = V_RES - 1;
  localparam signed V_NEG_START = 0 - (V_SIG_LEN - V_RES);

  assign beam_at_zero = (beam_x == 0) && (beam_y == 0);
  assign frame_start = (beam_y == V_NEG_START) && (beam_x == H_NEG_START);
  assign line_start = (beam_x == H_NEG_START);

  assign video_enable = (beam_x >= 0 && beam_x < H_RES) && (beam_y >= 0 && beam_y < V_RES);

  assign h_blank = (beam_x >= 0 && beam_x < H_RES) ? 0 : 1;
  assign v_blank = (beam_y >= 0 && beam_y < V_RES) ? 0 : 1;

  /*
  | beam_x | h_sync | note                                  |
  |--------|--------|---------------------------------------|
  | 0      | 0      |                                       |
  | 1      | 0      |                                       |
  | ...    |        |                                       |
  | 655    | 0      | 0 to 655 is 656                       |
  | 656    | 1      | H_RES + H_FRONT_PORCH                 |
  | ...    |        |                                       |
  | 751    | 1      | 656 to 751 is 96 (H_SYNC_PULSE)       |
  | 752    | 0      | H_RES + H_FRONT_PORCH + H_SYNC_PULSE  |
  | ...    |        |                                       |
  normal      639   640   641   655   656   751   752   799   800
  wrap-around 639  -160  -159  -145  -144   -49   -48    -1     0
  */
  // non-wrap-around logic
  // assign h_sync = (beam_x >= H_RES + H_FRONT_PORCH) && (beam_x < H_RES + H_FRONT_PORCH + H_SYNC_PULSE) ? H_SYNC_POL : !H_SYNC_POL;
  // wrap-around - offset beam_x by H_SIG_LEN to bring back in range
  assign h_sync = (H_SIG_LEN + beam_x >= H_RES + H_FRONT_PORCH) && (H_SIG_LEN + beam_x < H_RES + H_FRONT_PORCH + H_SYNC_PULSE) ? H_SYNC_POL : !H_SYNC_POL;

  /*
  | beam_y | v_sync | note                                  |
  |--------|--------|---------------------------------------|
  | 0      | 0      |                                       |
  | 1      | 0      |                                       |
  | ...    |        |                                       |
  | 489    | 0      | 0 to 489 is 490                       |
  | 490    | 1      | V_RES + V_FRONT_PORCH                 |
  | 491    | 1      | 490 to 491 is 2 (V_SYNC_PULSE)        |
  | 492    | 0      | V_RES + V_FRONT_PORCH + V_SYNC_PULSE  |
  | ...    |        |                                       |
  normal      479   480   489   490   491   492   524   525
  wrap-around 479   -45   -36   -35   -34   -33    -1     0
  */
  // non-wrap-around logic
  // assign v_sync = (beam_y >= V_RES + V_FRONT_PORCH) && (beam_y < V_RES + V_FRONT_PORCH + V_SYNC_PULSE) ? V_SYNC_POL : !V_SYNC_POL;
  // wrap-around - offset beam_y by V_SIG_LEN to bring back in range
  assign v_sync = (V_SIG_LEN + beam_y >= V_RES + V_FRONT_PORCH) && (V_SIG_LEN + beam_y < V_RES + V_FRONT_PORCH + V_SYNC_PULSE) ? V_SYNC_POL : !V_SYNC_POL;

  logic signed [COORDSPC-1:0] l_beam_x, l_beam_y;  // latched beam position
  always_ff @(posedge clk) begin
    if (reset) begin
      beam_x <= 0;
      beam_y <= 0;
    end else begin
      beam_x <= l_beam_x;
      beam_y <= l_beam_y;
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      signals_valid <= 0;
    end else begin
      signals_valid <= 1;
      // implement -ve wrap-around
      if (l_beam_x == H_DRAW_END) begin
        l_beam_x <= H_NEG_START;
        l_beam_y <= (l_beam_y == V_DRAW_END) ? V_NEG_START : l_beam_y + 1;
      end else begin
        l_beam_x <= l_beam_x + 1;
      end
    end
  end

endmodule  // VIDEO_timing_signals
