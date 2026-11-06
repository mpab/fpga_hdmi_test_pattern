# HDMI Test Pattern Generator

What does it do?  
A simple FPGA application which displays a test pattern.

![Screencap](./docs/specific/screencap.png)

![Vivado Design](./docs/specific/vivado_block_design.png)

## Source Code/Logic for Pattern Generation

```systemverilog
module VIDEO_test_pattern #(
    COORDSPC = 16,  // coordinate space (bits)
    COLSPC   = 10
) (
    input wire clk,
    input wire signed [COORDSPC-1:0] beam_x,
    input wire signed [COORDSPC-1:0] beam_y,
    output logic [COLSPC-1:0] red,
    output logic [COLSPC-1:0] green,
    output logic [COLSPC-1:0] blue
);
  wire [COLSPC-1:0] SX = beam_x[COLSPC-1:0];
  wire [COLSPC-1:0] SY = beam_y[COLSPC-1:0];
  wire [COLSPC-1:0] W = {COLSPC{SX[7:0] == SY[7:0]}};
  wire [COLSPC-1:0] A = {COLSPC{SX[7:5] == 3'h2 && SY[7:5] == 3'h2}};

  always_ff @(posedge clk) begin
    red   <= ({SX[5:0] & {6{SY[4:3] == ~SX[4:3]}}, 4'b0} | W) & ~A;
    green <= (SX & {COLSPC{SY[6]}} | W) & ~A;
    blue  <= SY | W | A;
  end
endmodule
```
