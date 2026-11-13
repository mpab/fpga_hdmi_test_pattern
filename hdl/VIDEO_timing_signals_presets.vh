// =============================================================================
// File: VIDEO_timing_signals_presets.vh
// =============================================================================

`ifndef VIDEO_TIMING_SIGNALS_PRESETS_VH
`define VIDEO_TIMING_SIGNALS_PRESETS_VH

// Resolution Selector Codes
localparam [1:0] RES_640x480 = 2'd0;
localparam [1:0] RES_800x600 = 2'd1;
localparam [1:0] RES_1280x720 = 2'd2;
localparam [1:0] RES_1024x768 = 2'd3;

// Parameter indexes/offsets
localparam int I_H_RES = 0;  // drawable columns
localparam int I_H_FRONT_PORCH = 1;  // horizontal front porch
localparam int I_H_SYNC_PULSE = 2;  // horizontal sync
localparam int I_H_BACK_PORCH = 3;  // horizontal back porch
localparam int I_H_SYNC_POL = 4;  // horizontal sync polarity (0:neg, 1:pos)
localparam int I_V_RES = 5;  // drawable rows
localparam int I_V_FRONT_PORCH = 6;  // vertical front porch
localparam int I_V_SYNC_PULSE = 7;  // vertical sync
localparam int I_V_BACK_PORCH = 8;  // vertical back porch
localparam int I_V_SYNC_POL = 9;  // vertical sync polarity (0:neg, 1:pos)

localparam int VTS_CFG[4][10] = '{
    '{640, 16, 96, 48, 0, 480, 10, 2, 33, 0},  // RES_640x480
    '{800, 40, 128, 88, 1, 600, 1, 4, 23, 1},  // RES_800x600
    '{1280, 110, 40, 220, 1, 720, 5, 5, 20, 1},  // RES_1280x720
    '{1024, 24, 136, 160, 0, 768, 5, 5, 20, 0}  // RES_1024x768
};

// Usage:
// H_RES for 1280x720 resolution = VTS_CFG[RES_1280x720][H_RES];

`endif
