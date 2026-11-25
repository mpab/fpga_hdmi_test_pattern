`timescale 1ns / 1ps

module test (
    input clk,
    input reset,

    input pal,
    input scandouble,
    input [1:0] buttons,

    output reg ce_pix,
    output     hvcnt_atzero,

    output reg HBlank,
    output reg HSync,
    output reg VBlank,
    output reg VSync,

    output reg [3*COLOR_BITS-1:0] rgb_data  // 3x8 bits rgb = 24 bit color
);
  import globals_pkg::*;
  mycore u_mycore (.*);

endmodule
