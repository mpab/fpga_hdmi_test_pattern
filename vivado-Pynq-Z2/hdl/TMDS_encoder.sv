// ============================================================================
// File: tmds_encoder.sv
// Description: IEEE/DVI 1.0 compliant 8b/10b DC-balanced TMDS encoder.
//              Includes output pipeline registers to isolate fabric LUT logic
//              from OSERDESE2 IOB routing delays.
// ============================================================================
module tmds_encoder (
    input  logic       pixel_clk,
    input  logic       pixel_rst_n,  // Active-low synchronous/async reset
    input  logic [7:0] vd,           // 8-bit color channel data
    input  logic [1:0] cd,           // 2-bit control data ({C1, C0})
    input  logic       vde,          // Video Data Enable (1 = active pixel)
    output logic [9:0] tmds_out      // 10-bit encoded TMDS symbol (registered)
);
  // Stage 1: Count ones in vd[7:0] and decide XOR vs XNOR encoding
  logic [3:0] n1_vd;
  logic       use_xnor;
  logic [8:0] q_m;

  always_comb begin
    n1_vd    = vd[0] + vd[1] + vd[2] + vd[3] + vd[4] + vd[5] + vd[6] + vd[7];
    use_xnor = (n1_vd > 4'd4) || ((n1_vd == 4'd4) && (vd[0] == 1'b0));

    q_m[0] = vd[0];
    q_m[1] = use_xnor ? (q_m[0] ~^ vd[1]) : (q_m[0] ^ vd[1]);
    q_m[2] = use_xnor ? (q_m[1] ~^ vd[2]) : (q_m[1] ^ vd[2]);
    q_m[3] = use_xnor ? (q_m[2] ~^ vd[3]) : (q_m[2] ^ vd[3]);
    q_m[4] = use_xnor ? (q_m[3] ~^ vd[4]) : (q_m[3] ^ vd[4]);
    q_m[5] = use_xnor ? (q_m[4] ~^ vd[5]) : (q_m[4] ^ vd[5]);
    q_m[6] = use_xnor ? (q_m[5] ~^ vd[6]) : (q_m[5] ^ vd[6]);
    q_m[7] = use_xnor ? (q_m[6] ~^ vd[7]) : (q_m[6] ^ vd[7]);
    q_m[8] = ~use_xnor;
  end

  // Pipeline Stage 1 -> Stage 2 for clean timing closure up to 75+ MHz
  logic [8:0] q_m_reg;
  logic [1:0] cd_reg;
  logic       vde_reg;

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      q_m_reg <= 9'd0;
      cd_reg  <= 2'b00;
      vde_reg <= 1'b0;
    end else begin
      q_m_reg <= q_m;
      cd_reg  <= cd;
      vde_reg <= vde;
    end
  end

  // Stage 2: Disparity calculation & 10-bit symbol generation
  logic [3:0] n1_qm, n0_qm;
  logic signed [4:0] disparity_diff;
  logic signed [4:0] cnt;  // Running disparity counter

  always_comb begin
    n1_qm          = q_m_reg[0] + q_m_reg[1] + q_m_reg[2] + q_m_reg[3] +
                         q_m_reg[4] + q_m_reg[5] + q_m_reg[6] + q_m_reg[7];
    n0_qm = 4'd8 - n1_qm;
    disparity_diff = $signed({1'b0, n1_qm}) - $signed({1'b0, n0_qm});
  end

  always_ff @(posedge pixel_clk or negedge pixel_rst_n) begin
    if (!pixel_rst_n) begin
      cnt      <= 5'sd0;
      tmds_out <= 10'b1101010100;  // Control symbol for cd=2'b00
    end else begin
      if (!vde_reg) begin
        // Blanking period: reset disparity and emit DVI control tokens
        cnt <= 5'sd0;
        case (cd_reg)
          2'b00:   tmds_out <= 10'b1101010100;
          2'b01:   tmds_out <= 10'b0010101011;
          2'b10:   tmds_out <= 10'b0101010100;
          default: tmds_out <= 10'b1010101011;
        endcase
      end else begin
        if ((cnt == 5'sd0) || (n1_qm == n0_qm)) begin
          tmds_out[9]   <= ~q_m_reg[8];
          tmds_out[8]   <= q_m_reg[8];
          tmds_out[7:0] <= q_m_reg[8] ? q_m_reg[7:0] : ~q_m_reg[7:0];
          if (q_m_reg[8] == 1'b0) cnt <= cnt - disparity_diff;
          else cnt <= cnt + disparity_diff;
        end else if (((cnt > 5'sd0) && (n1_qm > n0_qm)) || ((cnt < 5'sd0) && (n0_qm > n1_qm))) begin
          tmds_out[9] <= 1'b1;
          tmds_out[8] <= q_m_reg[8];
          tmds_out[7:0] <= ~q_m_reg[7:0];
          cnt <= cnt + $signed({3'b0, q_m_reg[8], 1'b0}) - disparity_diff;
        end else begin
          tmds_out[9] <= 1'b0;
          tmds_out[8] <= q_m_reg[8];
          tmds_out[7:0] <= q_m_reg[7:0];
          cnt <= cnt - $signed({3'b0, ~q_m_reg[8], 1'b0}) + disparity_diff;
        end
      end
    end
  end

endmodule
