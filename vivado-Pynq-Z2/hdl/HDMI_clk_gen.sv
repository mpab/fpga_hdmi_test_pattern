// ============================================================================
// File: hdmi_clk_gen.sv
// Description: Programmable MMCM clock generator using Xilinx DRP (XAPP888).
//              Takes 125 MHz board clock (H16) and generates phase-aligned
//              PixelClk (1x) and TmdsClk (5x DDR) on dedicated BUFGs.
// ============================================================================
module hdmi_clk_gen
  import globals_pkg::*;
  import hdmi_clk_gen_pkg::*;
(
    input  logic       sys_clk_125m,  // Board 125 MHz oscillator (H16)
    input  logic       sys_rst_n,     // Active-low async reset
    input  logic [1:0] res_sel,       // Video resolution selector
    output logic       pixel_clk,     // 1x Pixel Clock (BUFG)
    output logic       tmds_clk,      // 5x TMDS DDR Clock (BUFG)
    output logic       clk_locked     // High when MMCM is locked and DRP idle
);
  // Synchronize res_sel into sys_clk_125m domain and detect changes
  logic [1:0] res_sync_0, res_sync_1, mode_active;
  always_ff @(posedge sys_clk_125m or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      res_sync_0 <= RES_DEFAULT;
      res_sync_1 <= RES_DEFAULT;
    end else begin
      res_sync_0 <= res_sel;
      res_sync_1 <= res_sync_0;
    end
  end

  // DRP interface signals
  logic          [ 6:0] daddr;
  logic                 den;
  logic          [15:0] di;
  logic          [15:0] do_data;
  logic                 drdy;
  logic                 dwe;
  logic                 mmcm_rst;
  logic                 mmcm_locked_raw;

  mmcm_drp_cfg_t        target_cfg;
  assign target_cfg = get_mmcm_cfg(mode_active);

  // DRP State Machine (Read-Modify-Write per Xilinx XAPP888)
  typedef enum logic [3:0] {
    ST_IDLE       = 4'd0,
    ST_ASSERT_RST = 4'd1,
    ST_READ_REQ   = 4'd2,
    ST_READ_WAIT  = 4'd3,
    ST_WRITE_REQ  = 4'd4,
    ST_WRITE_WAIT = 4'd5,
    ST_REL_RST    = 4'd6,
    ST_WAIT_LOCK  = 4'd7
  } drp_state_e;

  drp_state_e state;
  logic [2:0] reg_idx;
  logic [15:0] write_val, write_mask;

  // Select DRP register address, new value, and bitmask per step
  always_comb begin
    case (reg_idx)
      3'd0: begin  // CLKFBOUT Reg1 (0x14): [11:0] high/low time
        daddr      = 7'h14;
        write_val  = target_cfg.clkfb_reg1;
        write_mask = 16'h1000;  // Preserve bit 12
      end
      3'd1: begin  // CLKFBOUT Reg2 (0x15): [7:6] edge/no_count
        daddr      = 7'h15;
        write_val  = target_cfg.clkfb_reg2;
        write_mask = 16'hFC00;  // Preserve [15:10] fractional bits
      end
      3'd2: begin  // CLKOUT0 Reg1 (0x08): [11:0] high/low time
        daddr      = 7'h08;
        write_val  = target_cfg.clk0_reg1;
        write_mask = 16'h1000;
      end
      3'd3: begin  // CLKOUT0 Reg2 (0x09): [7:6] edge/no_count
        daddr      = 7'h09;
        write_val  = target_cfg.clk0_reg2;
        write_mask = 16'hFC00;
      end
      3'd4: begin  // CLKOUT1 Reg1 (0x0A): [11:0] high/low time
        daddr      = 7'h0A;
        write_val  = target_cfg.clk1_reg1;
        write_mask = 16'h1000;
      end
      3'd5: begin  // CLKOUT1 Reg2 (0x0B): [7:6] edge/no_count
        daddr      = 7'h0B;
        write_val  = target_cfg.clk1_reg2;
        write_mask = 16'hFC00;
      end
      default: begin
        daddr      = 7'h14;
        write_val  = 16'h0000;
        write_mask = 16'hFFFF;
      end
    endcase
  end

  always_ff @(posedge sys_clk_125m or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      state       <= ST_IDLE;
      mode_active <= RES_DEFAULT;
      reg_idx     <= 3'd0;
      den         <= 1'b0;
      dwe         <= 1'b0;
      di          <= 16'h0000;
      mmcm_rst    <= 1'b0;
    end else begin
      den <= 1'b0;
      dwe <= 1'b0;

      case (state)
        ST_IDLE: begin
          mmcm_rst <= 1'b0;
          if (res_sync_1 != mode_active) begin
            mode_active <= res_sync_1;
            reg_idx     <= 3'd0;
            state       <= ST_ASSERT_RST;
          end
        end

        ST_ASSERT_RST: begin
          mmcm_rst <= 1'b1; // Hold MMCM in reset during DRP writes
          state    <= ST_READ_REQ;
        end

        ST_READ_REQ: begin
          den   <= 1'b1;
          dwe   <= 1'b0;
          state <= ST_READ_WAIT;
        end

        ST_READ_WAIT: begin
          if (drdy) begin
            di    <= (do_data & write_mask) | (write_val & ~write_mask);
            state <= ST_WRITE_REQ;
          end
        end

        ST_WRITE_REQ: begin
          den   <= 1'b1;
          dwe   <= 1'b1;
          state <= ST_WRITE_WAIT;
        end

        ST_WRITE_WAIT: begin
          if (drdy) begin
            if (reg_idx == 3'd5) begin
              state <= ST_REL_RST;
            end else begin
              reg_idx <= reg_idx + 3'd1;
              state   <= ST_READ_REQ;
            end
          end
        end

        ST_REL_RST: begin
          mmcm_rst <= 1'b0;
          state    <= ST_WAIT_LOCK;
        end

        ST_WAIT_LOCK: begin
          if (mmcm_locked_raw) begin
            state <= ST_IDLE;
          end
        end

        default: state <= ST_IDLE;
      endcase
    end
  end

  assign clk_locked = mmcm_locked_raw && (state == ST_IDLE);

  // Raw MMCM clocks and feedback
  logic clkfb_out, clkfb_buf;
  logic clk0_tmds_raw, clk1_pixel_raw;

  // Default boot configuration: Mode 1 (800x600 @ 60Hz -> 200MHz / 40MHz)
  MMCME2_ADV #(
      .BANDWIDTH           ("OPTIMIZED"),
      .CLKFBOUT_MULT_F     (40.000),       // VCO = 125MHz * 40 / 5 = 1000 MHz
      .CLKFBOUT_PHASE      (0.000),
      .CLKFBOUT_USE_FINE_PS("FALSE"),
      .CLKIN1_PERIOD       (8.000),        // 125 MHz input clock
      .CLKOUT0_DIVIDE_F    (5.000),        // 200.0 MHz TmdsClk
      .CLKOUT0_DUTY_CYCLE  (0.500),
      .CLKOUT0_PHASE       (0.000),
      .CLKOUT1_DIVIDE      (25),           // 40.0 MHz PixelClk
      .CLKOUT1_DUTY_CYCLE  (0.500),
      .CLKOUT1_PHASE       (0.000),
      .COMPENSATION        ("ZHOLD"),
      .DIVCLK_DIVIDE       (5),            // PFD = 25 MHz
      .REF_JITTER1         (0.010),
      .STARTUP_WAIT        ("FALSE")
  ) u_mmcm_adv (
      .CLKFBOUT    (clkfb_out),
      .CLKFBOUTB   (),
      .CLKFBSTOPPED(),
      .CLKINSTOPPED(),
      .CLKOUT0     (clk0_tmds_raw),
      .CLKOUT0B    (),
      .CLKOUT1     (clk1_pixel_raw),
      .CLKOUT1B    (),
      .CLKOUT2     (),
      .CLKOUT2B    (),
      .CLKOUT3     (),
      .CLKOUT3B    (),
      .CLKOUT4     (),
      .CLKOUT5     (),
      .CLKOUT6     (),
      .DO          (do_data),
      .DRDY        (drdy),
      .LOCKED      (mmcm_locked_raw),
      .PSDONE      (),
      .CLKFBIN     (clkfb_buf),
      .CLKIN1      (sys_clk_125m),
      .CLKIN2      (1'b0),
      .CLKINSEL    (1'b1),
      .DADDR       (daddr),
      .DCLK        (sys_clk_125m),
      .DEN         (den),
      .DI          (di),
      .DWE         (dwe),
      .PSCLK       (1'b0),
      .PSEN        (1'b0),
      .PSINCDEC    (1'b0),
      .PWRDWN      (1'b0),
      .RST         ((~sys_rst_n) | mmcm_rst)
  );

  // Dedicated global buffers for feedback, 1x pixel clock, and 5x tmds clock
  BUFG u_bufg_fb (
      .I(clkfb_out),
      .O(clkfb_buf)
  );
  BUFG u_bufg_pixel (
      .I(clk1_pixel_raw),
      .O(pixel_clk)
  );
  BUFG u_bufg_tmds (
      .I(clk0_tmds_raw),
      .O(tmds_clk)
  );

endmodule
