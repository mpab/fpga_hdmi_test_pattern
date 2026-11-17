// ============================================================================
// File: tmds_oserdes_10to1.sv
// Description: 10:1 DDR Serializer using cascaded MASTER/SLAVE OSERDESE2
//              primitives + OBUFDS per Xilinx UG471.
// ============================================================================
module tmds_oserdes_10to1 (
    input  logic       pixel_clk,   // 1x parallel pixel clock (BUFG)
    input  logic       tmds_clk,    // 5x high-speed DDR tmds clock (BUFG)
    input  logic       serdes_rst,  // Active-HIGH reset synchronous to pixel_clk
    input  logic [9:0] tmds_data,   // 10-bit parallel TMDS symbol (LSB first)
    output logic       tmds_p,      // Differential positive output pad
    output logic       tmds_n       // Differential negative output pad
);
  logic tmds_oq;
  logic shift_out_1, shift_out_2;

  // MASTER OSERDESE2: serializes bits [7:0] + cascaded [9:8] from SLAVE
  OSERDESE2 #(
      .DATA_RATE_OQ  ("DDR"),
      .DATA_RATE_TQ  ("SDR"),
      .DATA_WIDTH    (10),
      .INIT_OQ       (1'b0),
      .INIT_TQ       (1'b0),
      .SERDES_MODE   ("MASTER"),
      .SRVAL_OQ      (1'b0),
      .SRVAL_TQ      (1'b0),
      .TBYTE_CTL     ("FALSE"),
      .TBYTE_SRC     ("FALSE"),
      .TRISTATE_WIDTH(1)
  ) u_oserdes_master (
      .OFB      (),
      .OQ       (tmds_oq),
      .SHIFTOUT1(),
      .SHIFTOUT2(),
      .TBYTEOUT (),
      .TFB      (),
      .TQ       (),
      .CLK      (tmds_clk),
      .CLKDIV   (pixel_clk),
      .D1       (tmds_data[0]),
      .D2       (tmds_data[1]),
      .D3       (tmds_data[2]),
      .D4       (tmds_data[3]),
      .D5       (tmds_data[4]),
      .D6       (tmds_data[5]),
      .D7       (tmds_data[6]),
      .D8       (tmds_data[7]),
      .OCE      (1'b1),
      .RST      (serdes_rst),
      .SHIFTIN1 (shift_out_1),
      .SHIFTIN2 (shift_out_2),
      .T1       (1'b0),
      .T2       (1'b0),
      .T3       (1'b0),
      .T4       (1'b0),
      .TBYTEIN  (1'b0),
      .TCE      (1'b0)
  );

  // SLAVE OSERDESE2: shifts upper bits [9:8] via D3/D4 per UG471 Table 3-13
  OSERDESE2 #(
      .DATA_RATE_OQ  ("DDR"),
      .DATA_RATE_TQ  ("SDR"),
      .DATA_WIDTH    (10),
      .INIT_OQ       (1'b0),
      .INIT_TQ       (1'b0),
      .SERDES_MODE   ("SLAVE"),
      .SRVAL_OQ      (1'b0),
      .SRVAL_TQ      (1'b0),
      .TBYTE_CTL     ("FALSE"),
      .TBYTE_SRC     ("FALSE"),
      .TRISTATE_WIDTH(1)
  ) u_oserdes_slave (
      .OFB      (),
      .OQ       (),
      .SHIFTOUT1(shift_out_1),
      .SHIFTOUT2(shift_out_2),
      .TBYTEOUT (),
      .TFB      (),
      .TQ       (),
      .CLK      (tmds_clk),
      .CLKDIV   (pixel_clk),
      .D1       (1'b0),
      .D2       (1'b0),
      .D3       (tmds_data[8]),
      .D4       (tmds_data[9]),
      .D5       (1'b0),
      .D6       (1'b0),
      .D7       (1'b0),
      .D8       (1'b0),
      .OCE      (1'b1),
      .RST      (serdes_rst),
      .SHIFTIN1 (1'b0),
      .SHIFTIN2 (1'b0),
      .T1       (1'b0),
      .T2       (1'b0),
      .T3       (1'b0),
      .T4       (1'b0),
      .TBYTEIN  (1'b0),
      .TCE      (1'b0)
  );

  // Differential tmds_33 output buffer (placed in IOB adjacent to OSERDESE2)
  OBUFDS #(
      .IOSTANDARD("tmds_33"),
      .SLEW      ("FAST")
  ) u_obufds (
      .O (tmds_p),
      .OB(tmds_n),
      .I (tmds_oq)
  );

endmodule
