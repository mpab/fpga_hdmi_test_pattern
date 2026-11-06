`timescale 1ns / 1ps

// generates clk and video_clk_tmds from sysclk
module HDMI_sig_gen #(
    COORDSPC = 16  // coordinate space (bits)
) (
    input wire sysclk,  // 125MHz
    output logic clk,
    output logic video_clk_tmds
);
  ////////////////////////////////////////////////////////////////////////
  // sysclk divider 125 MHz to 25 MHz clk_pix, and multiplier 125 MHz to 250 MHz
  logic MMCM_pix_clock;
  logic DCM_TMDS_CLKFX;
  logic clkfb_in, clkfb_out;

  logic CLKOUT0, CLKOUT0B, CLKOUT1B, CLKOUT2B, CLKOUT3, CLKOUT3B;
  logic CLKOUT4, CLKOUT5, CLKOUT6, CLKFBOUTB, LOCKED, PWRDWN;
  // MMCME2_BASE: Base Mixed Mode Clock Manager
  //              Artix-7
  // Xilinx HDL Language Template, version 2020.1

  MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),  // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(6.0),  // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),  // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(8.0),  // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT1_DIVIDE(30),  // 125*6/30 = 25 MHz
      .CLKOUT2_DIVIDE(3),  // 125*6/3  = 250 MHz
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT6_DIVIDE(1),
      .CLKOUT0_DIVIDE_F(1.0),  // Divide amount for CLKOUT0 (1.000-128.000).
      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),
      .CLKOUT4_CASCADE("FALSE"),  // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .DIVCLK_DIVIDE(1),  // Master division value (1-106)
      .REF_JITTER1(0.0),  // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT("FALSE")  // Delays DONE until MMCM is locked (FALSE, TRUE)
  ) MMCME2_BASE_INST (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0  (CLKOUT0),         // 1-bit output: CLKOUT0
      .CLKOUT0B (CLKOUT0B),        // 1-bit output: Inverted CLKOUT0
      .CLKOUT1  (MMCM_pix_clock),  // 1-bit output: CLKOUT1
      .CLKOUT1B (CLKOUT1B),        // 1-bit output: Inverted CLKOUT1
      .CLKOUT2  (DCM_TMDS_CLKFX),  // 1-bit output: CLKOUT2
      .CLKOUT2B (CLKOUT2B),        // 1-bit output: Inverted CLKOUT2
      .CLKOUT3  (CLKOUT3),         // 1-bit output: CLKOUT3
      .CLKOUT3B (CLKOUT3B),        // 1-bit output: Inverted CLKOUT3
      .CLKOUT4  (CLKOUT4),         // 1-bit output: CLKOUT4
      .CLKOUT5  (CLKOUT5),         // 1-bit output: CLKOUT5
      .CLKOUT6  (CLKOUT6),         // 1-bit output: CLKOUT6
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT (clkfb_in),        // 1-bit output: Feedback clock
      .CLKFBOUTB(CLKFBOUTB),       // 1-bit output: Inverted CLKFBOUT
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED   (LOCKED),          // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1   (sysclk),          // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN   (PWRDWN),          // 1-bit input: Power-down
      .RST      (1'b0),            // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN  (clkfb_out)        // 1-bit input: Feedback clock
  );

  // End of MMCME2_BASE_inst instantiation

  // clock buffers
  // BUFG: Global Clock Simple Buffer
  //       Artix-7
  // Xilinx HDL Language Template, version 2020.1

  BUFG BUFG_clk_pix (
      .O(clk),  // 1-bit output: Clock output
      .I(MMCM_pix_clock)  // 1-bit input: Clock input
  );

  // BUFG: Global Clock Simple Buffer
  //       Artix-7
  // Xilinx HDL Language Template, version 2020.1

  BUFG BUFG_TMDSp (
      .O(video_clk_tmds),  // 1-bit output: Clock output
      .I(DCM_TMDS_CLKFX)   // 1-bit input: Clock input
  );

  // BUFG: Global Clock Simple Buffer
  //       Artix-7
  // Xilinx HDL Language Template, version 2020.1

  BUFG BUFG_CLKFB (
      .O(clkfb_out),  // 1-bit output: Clock output
      .I(clkfb_in)    // 1-bit input: Clock input
  );
endmodule  // HDMI_sig_gen
