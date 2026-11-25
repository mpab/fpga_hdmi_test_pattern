`timescale 1ns / 1ps
// ============================================================================
// File: video_timing_pkg.sv
// Description: Video constants and timing parameters
// ============================================================================
package video_timing_pkg;
  import globals_pkg::*;

  typedef struct packed {
    logic [COORD_BITS-1:0] h_res;    // horizontal usable/writable pixels
    logic [COORD_BITS-1:0] h_fp;     // horizontal front porch
    logic [COORD_BITS-1:0] h_sync;
    logic [COORD_BITS-1:0] h_bp;     // horizontal back porch
    logic                  h_pol;    // 1 = active high, 0 = active low
    logic [COORD_BITS-1:0] v_res;    // vertical usable/writable pixels
    logic [COORD_BITS-1:0] v_fp;     // vertical front porch
    logic [COORD_BITS-1:0] v_sync;
    logic [COORD_BITS-1:0] v_bp;     // vertical back porch
    logic                  v_pol;    // 1 = active high, 0 = active low
    logic [COORD_BITS-1:0] h_total;  // h_res + h_fp + h_sync + h_bp
    logic [COORD_BITS-1:0] v_total;  // v_res + v_fp + v_sync + v_bp
  } video_timing_t;

  typedef struct packed {
    logic [COORD_BITS-1:0] x;
    logic [COORD_BITS-1:0] y;
  } coord_t;

  // One record per resolution. Quartus rejects an unpacked array of packed structs
  // initialized with struct literals, so use separate scalar localparam records.
  // The final two fields are 0,0 placeholders; get_video_timing() fills h_total/v_total.
  localparam video_timing_t VIDEO_640x480_60 = '{640, 16, 96, 48, 1'b0, 480, 10, 2, 33, 1'b0, 0, 0};
  localparam video_timing_t VIDEO_800x600_60 = '{800, 40, 128, 88, 1'b1, 600, 1, 4, 23, 1'b1, 0, 0};
  localparam video_timing_t VIDEO_1024x768_60 = '{
      1024,
      24,
      136,
      160,
      1'b0,
      768,
      3,
      6,
      29,
      1'b0,
      0,
      0
  };
  localparam video_timing_t VIDEO_1280x720_60 = '{
      1280,
      110,
      40,
      220,
      1'b1,
      720,
      5,
      5,
      20,
      1'b1,
      0,
      0
  };
  // Can be extended - e.g.
  // RES_1920x1080_30 '{1920, 88, 44, 148, 1'b1, 1080, 4, 5, 36, 1'b1};

  function automatic logic [COORD_BITS-1:0] get_h_total(input video_timing_t cfg);
    return cfg.h_res + cfg.h_fp + cfg.h_sync + cfg.h_bp;
  endfunction

  function automatic logic [COORD_BITS-1:0] get_v_total(input video_timing_t cfg);
    return cfg.v_res + cfg.v_fp + cfg.v_sync + cfg.v_bp;
  endfunction

  // Return a complete record: the per-resolution parameters plus their derived totals.
  function automatic video_timing_t get_video_timing(input logic [1:0] mode);
    video_timing_t cfg;
    unique case (mode)
      RES_640x480_60:  cfg = VIDEO_640x480_60;
      RES_800x600_60:  cfg = VIDEO_800x600_60;
      RES_1024x768_60: cfg = VIDEO_1024x768_60;
      RES_1280x720_60: cfg = VIDEO_1280x720_60;
    endcase
    cfg.h_total = get_h_total(cfg);
    cfg.v_total = get_v_total(cfg);
    return cfg;
  endfunction

  // Beam position after the requested number of registered output handoffs.
  function automatic coord_t get_beam_lookahead(input coord_t pos, input video_timing_t cfg,
                                                input logic [COORD_BITS-1:0] delay);
    logic [COORD_BITS-1:0] delayed_x;
    logic [COORD_BITS-1:0] delayed_y;
    logic [COORD_BITS-1:0] la_x;
    logic [COORD_BITS-1:0] la_y;

    delayed_x = pos.x + delay;
    la_x = (delayed_x >= cfg.h_total) ? (delayed_x - cfg.h_total) : delayed_x;

    delayed_y = pos.y + (delayed_x >= cfg.h_total ? 1 : 0);
    la_y = (delayed_y >= cfg.v_total) ? (delayed_y - cfg.v_total) : delayed_y;

    return '{la_x, la_y};
  endfunction

endpackage
