`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_signals_pkg.sv
// Description: Video constants and timing parameters
// ============================================================================
package video_timing_signals_pkg;
  import globals_pkg::*;

  typedef struct packed {
    logic [11:0] h_active;
    logic [11:0] h_fp;
    logic [11:0] h_sync;
    logic [11:0] h_bp;
    logic        h_pol;     // 1 = active high, 0 = active low
    logic [11:0] v_active;
    logic [11:0] v_fp;
    logic [11:0] v_sync;
    logic [11:0] v_bp;
    logic        v_pol;     // 1 = active high, 0 = active low
  } video_timing_t;

  function automatic video_timing_t get_video_timing(input logic [1:0] mode);
    case (mode)
      //RES_640x480_60:
      //return '{12'd640, 12'd16, 12'd96, 12'd48, 1'b0, 12'd480, 12'd10, 12'd2, 12'd33, 1'b0};
      RES_800x600_60:
      return '{12'd800, 12'd40, 12'd128, 12'd88, 1'b1, 12'd600, 12'd1, 12'd4, 12'd23, 1'b1};
      RES_1024x768_60:
      return '{12'd1024, 12'd24, 12'd136, 12'd160, 1'b0, 12'd768, 12'd3, 12'd6, 12'd29, 1'b0};
      RES_1280x720_60:
      return '{12'd1280, 12'd110, 12'd40, 12'd220, 1'b1, 12'd720, 12'd5, 12'd5, 12'd20, 1'b1};
      RES_1920x1080_30:
      return '{12'd1920, 12'd88, 12'd44, 12'd148, 1'b1, 12'd1080, 12'd4, 12'd5, 12'd36, 1'b1};
      default:
      return '{12'd800, 12'd40, 12'd128, 12'd88, 1'b1, 12'd600, 12'd1, 12'd4, 12'd23, 1'b1};
    endcase
  endfunction

endpackage
