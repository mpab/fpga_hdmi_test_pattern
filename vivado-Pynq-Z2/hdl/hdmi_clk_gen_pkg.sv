// ============================================================================
// File: hdmi_clk_gen_pkg.sv
// Description: Video mode parameters & MMCM DRP register definitions for
//              PYNQ-Z2 (Zynq-7020 -1, 125 MHz sysclk).
// ============================================================================
package hdmi_clk_gen_pkg;
  import globals_pkg::*;
  import video_timing_signals_pkg::*;
  typedef struct packed {
    logic [15:0] clkfb_reg1;  // Addr 0x14: CLKFBOUT ClkReg1 (M)
    logic [15:0] clkfb_reg2;  // Addr 0x15: CLKFBOUT ClkReg2 (M)
    logic [15:0] clk0_reg1;   // Addr 0x08: CLKOUT0  ClkReg1 (TMDS 5x)
    logic [15:0] clk0_reg2;   // Addr 0x09: CLKOUT0  ClkReg2 (TMDS 5x)
    logic [15:0] clk1_reg1;   // Addr 0x0A: CLKOUT1  ClkReg1 (Pixel  1x)
    logic [15:0] clk1_reg2;   // Addr 0x0B: CLKOUT1  ClkReg2 (Pixel  1x)
  } mmcm_drp_cfg_t;

  // Precomputed per Xilinx XAPP888 (DIVCLK_DIVIDE = 5 fixed across all modes -> PFD = 25 MHz)
  function automatic mmcm_drp_cfg_t get_mmcm_cfg(input logic [1:0] mode);
    case (mode)
      // Mode 0: M=40 (VCO=1000MHz), O0=8 (125MHz), O1=40 (25MHz)
      RES_640x480_60: return '{16'h0514, 16'h0000, 16'h0104, 16'h0000, 16'h0514, 16'h0000};
      // Mode 1: M=40 (VCO=1000MHz), O0=5 (200MHz), O1=25 (40MHz)
      RES_800x600_60: return '{16'h0514, 16'h0000, 16'h0083, 16'h0080, 16'h030D, 16'h0080};
      // Mode 2: M=39 (VCO=975MHz),  O0=3 (325MHz), O1=15 (65MHz)
      RES_1024x768_60: return '{16'h04D4, 16'h0080, 16'h0042, 16'h0080, 16'h01C8, 16'h0080};
      // Mode 3: M=30 (VCO=750MHz), O0=2 (375MHz), O1=10 (75MHz)
      RES_1280x720_60: return '{16'h03CF, 16'h0000, 16'h0041, 16'h0000, 16'h0145, 16'h0000};
      // NOTE: RES_1920x1080_30 == RES_1280x720_60
      default:  /* 800x600 */ return '{16'h0514, 16'h0000, 16'h0083, 16'h0080, 16'h030D, 16'h0080};
    endcase
  endfunction

endpackage
