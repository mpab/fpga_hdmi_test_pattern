`timescale 1ns / 1ps
// ============================================================================
// File: globals_pkg.sv
// Description: global types, constants, etc.
// ============================================================================
package globals_pkg;
  typedef enum logic [1:0] {
    RES_640x480_60  = 2'd0,  // 25.00 MHz pixel / 125.00 MHz tmds (59.52 Hz)
    RES_800x600_60  = 2'd1,  // 40.00 MHz pixel / 200.00 MHz tmds (60.32 Hz)
    RES_1024x768_60 = 2'd2,  // 65.00 MHz pixel / 325.00 MHz tmds (60.00 Hz)
    RES_1280x720_60 = 2'd3   // 75.00 MHz pixel / 375.00 MHz tmds (60.61 Hz)
    // DISABLED RES_1920x1080_30 = 2'd3   // 75.00 MHz pixel / 375.00 MHz tmds (30.30 Hz CEA-861)
  } video_mode_e;
  localparam [1:0] RES_DEFAULT = RES_800x600_60;
  localparam int COORD_BITS = 12;
  localparam int COLOR_BITS = 8;
endpackage
