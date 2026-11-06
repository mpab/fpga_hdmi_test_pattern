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
## Quick Start

```sh
# To build for Xilinx/AMD (vivado/vitis)
# (defaults to Pynq-Z2)
make -f xilinx.mk

# To build for mister (quartus)
make -f verilator/Makefile

# To build for Verilator
make -f verilator/Makefile

# COMING SOON...
# To build for gowin
# (defaults to Tang Nano 20K)
make -f gowin/Makefile
```

## Folder Layout

```text
├── docs              documentation
├── env               environment variable scripts/helpers
├── env.mk            make environment variables
├── env.py            python environment variables
├── env.sh            shell environment variables
├── env.tcl           tcl environment variables
├── hdl               application firmware for all platforms
├── mister            mister platform (DE10 Nano)
├── out               build artifacts (and generated projects)
├── pynq              pynq sub-project for xilinx/AMD
├── README.md         readme - composed from ./docs
├── TODO.md           backlog
├── verilator         verilator simulation platform
├── vitis             vitis sub-project for xilinx/AMD platform
├── vivado            vivado sub-project for xilinx/AMD platform
├── vivado-Pynq-Z2    Pynq-Z2 xilinx/AMD platform target
└── xilinx.mk         make for orchestrating xilinx/AMD platform
```

## Prerequisites

### General

A Linux/MSYS2/WSL2 environment which supports:

- shell scripting
- GNU make > 4.x
- git
- (optional) python

### xilinx/AMD platform

- Tested on Xilinx/AMD toolchain > 2021.2  < 2026.1 (although other versions may work)
- Vitis toolchain on path
- XILINX_VERSION defined as an environment variable which tracks the current active xilinx/AMD toolchain
- XILINX_BOARD_STORE_PATH defined as an environment variable which tracks the current active xilinx/AMD toolchain
  - Linux/WSL2
    - XILINX_BOARD_STORE_PATH="$HOME/.Xilinx/Vivado/${XILINX_VERSION}/xhub/board_store/xilinx_board_store/"
  - Windows/MSYS
    - XILINX_BOARD_STORE_PATH=$(cygpath -m "$APPDATA/Xilinx/Vivado/${XILINX_VERSION}/xhub/board_store/xilinx_board_store/")

```sh
XILINX_VERSION=$(vivado -version | grep "vivado v" | sed "s/^.*vivado v//" | sed "s/ (64-bit)//")
```

### mister platform (DE10 Nano)

quartus toolchain and quartus_sh on the path (version 17 recommended)

### verilator simulation platform

vitis/vivado should be installed  
make (or cmake)

### Build Artifacts (./out/...) MB_APP_*

Naming convention for platform-dependent project output.

./out/${PLATFORM}_${PROJECT}_${TOOLCHAIN_VERSION}

### Dependency Management

- Build dependencies are dictated by Makefiles
- Build specifics are implemented in scripts

## PYNQ Overlay - copy overlay artifacts

Expects that a file: '${MB_APP_ROOT}/env/host_pynq' is present and is an ssh target.

e.g.

```text
xilinx@host.lan
```

```sh
./pynq/scp-to-host.sh
```

## Configuration and Customization

### Environment Variables

Environment variables are available to:

- Makefiles via env.mk
- Python scripts via env.py
- Shell scripts via env.sh
- tcl scripts via env.tcl

All env vars are available to all toolchains (with some exclusions/exceptions).  
To recreate (will not overwrite if env files exist).

```sh
./env/generate.sh

# to view
make -f ./env/print.mk
python ./env/print.py
./env/print.sh
tclsh ./env/print.tcl
```
