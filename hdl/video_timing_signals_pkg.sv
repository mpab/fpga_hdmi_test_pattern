`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_signals_pkg.sv
// Description: Video constants and timing parameters
// ============================================================================
package video_timing_signals_pkg;
  import globals_pkg::*;

  typedef struct packed {
    logic [COORD_BITS-1:0] h_res;   // horizontal usable/writable pixels
    logic [COORD_BITS-1:0] h_fp;    // horizontal front porch
    logic [COORD_BITS-1:0] h_sync;
    logic [COORD_BITS-1:0] h_bp;    // horizontal back porch
    logic                  h_pol;   // 1 = active high, 0 = active low
    logic [COORD_BITS-1:0] v_res;   // vertical usable/writable pixels
    logic [COORD_BITS-1:0] v_fp;    // vertical front porch
    logic [COORD_BITS-1:0] v_sync;
    logic [COORD_BITS-1:0] v_bp;    // vertical back porch
    logic                  v_pol;   // 1 = active high, 0 = active low
  } video_timing_t;

  function automatic video_timing_t get_video_timing(input logic [1:0] mode);
    case (mode)
      RES_640x480_60: return '{640, 16, 96, 48, 1'b0, 480, 10, 2, 33, 1'b0};
      RES_800x600_60: return '{800, 40, 128, 88, 1'b1, 600, 1, 4, 23, 1'b1};
      RES_1024x768_60: return '{1024, 24, 136, 160, 1'b0, 768, 3, 6, 29, 1'b0};
      RES_1280x720_60: return '{1280, 110, 40, 220, 1'b1, 720, 5, 5, 20, 1'b1};
      // DISABLED RES_1920x1080_30:
      //return '{1920, 88, 44, 148, 1'b1, 1080, 4, 5, 36, 1'b1};
      default: return '{640, 16, 96, 48, 1'b0, 480, 10, 2, 33, 1'b0};
    endcase
  endfunction

endpackage
