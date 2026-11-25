# Project Conventions

## General

- No PowerShell scripts.
- Use Makefiles, shell scripts, TCL, and Python.
- Environment variables come from `env.sh`, `env.mk`, `env.tcl`, and `env.py`.
- Prefer implicit port matching when names/types match project-wide; use explicit connections only for cross-domain mapping.
- Keep generated code and binary artifacts out of the source tree (should be in ./out/..)
- Tests
  - Test projects live in `tests/$PROJ`.
  - Build output goes to `out/tests/$PROJ`.
  - Harness sources live in `tests/$PROJ/src/`.
  - Required harness files are `test.cpp` plus `test.sv` or `test.v`.
  - The HDL file is a wrapper, not a copied application module.
  - The C++ runner drives the wrapper through the wrapper module.
  - Avoid duplicated HDL source; reference the application module through include paths.

## Environment Variables

Environment variables are available in:

- `./env.sh`
- `./env.mk`
- `./env.tcl`
- `./env.py`

These are generated from:

```sh
./env/generate.sh
```

Makefiles should source `env.mk` rather than hard-code environment values.

## Coding Standards: SystemVerilog

### Module structure

- Use `module ... endmodule` for HDL components.
- Keep module names in lowercase snake_case.
- Use descriptive port names so interfaces are self-documenting.
- Prefer `logic` for HDL signals and state. Use `reg` only where a legacy interface explicitly requires it.
- Declare every variable before it is used; do not leave consumed signals uninitialized.

### Port connections

Prefer implicit port matching when the wrapper and referenced module use the same names and types:

```sv
mycore u_mycore (.*);
```

Use explicit connections only for cross-domain adaptation, i.e. where a port name differs:

```sv
hdmi_clk_gen u_clk_gen (
    .*,
    .sys_clk_125m(sys_clk)
);
```

or:

```sv
video_timing_signals_registered vts (
    .*,
    .beam_at_zero(hvcnt_atzero)
);
```

Rules:

- `.*` connects all remaining matching ports implicitly.
- Explicit mappings are for domain adaptation, not for repeating every matching port.
- Do not write only one explicit connection without `.*`; that leaves the other ports unconnected.
- If a full explicit port list is used, it must include every port. Otherwise use `.*`.

### Reset naming and semantics

Use consistent reset naming:

- `*_rst_n` means an active-low reset input.
- `*_rst` means an active-high reset signal.

Check active-low resets with:

```sv
if (!pixel_rst_n) begin
    ...
end
```

Check active-high resets with:

```sv
if (serdes_rst) begin
    ...
end
```

Synchronize reset across clock domains explicitly. Do not assume a reset in one clock domain is automatically valid in another.

### Sequential and combinational logic

Use:

- `always_ff @(posedge clk or negedge rst_n)` for registered state and counters.
- `always_comb` for pure combinational logic.
- `assign` for static aliasing and wiring.
- `unique case` where the cases are intended to be mutually exclusive.

Every `always_ff` block should explicitly handle reset state and normal state.

### Packages and configuration data

Use packages for constants and configuration data:

```sv
package globals_pkg;
```

Import package contents explicitly:

```sv
import globals_pkg::*;
import video_timing_pkg::*;
```

Use `typedef struct packed` for configuration records and `localparam` arrays for precomputed configurations.

### Naming conventions

Use consistent signal names across modules:

```text
pixel_clk
pixel_rst_n
h_sync
v_sync
h_blank
v_blank
```

Use `u_` prefixes for concrete component instances:

```sv
hdmi_clk_gen u_clk_gen (...);
tmds_encoder u_enc_blue (...);
tmds_oserdes_10to1 u_ser_blue (...);
```

Short domain names such as `vts` and `vs` are acceptable for brevity where repeating a long module name is unwieldy:

```sv
video_timing_signals_registered vts (...);
video_source vs (...);
```

Use uppercase names for constants and configuration identifiers.

### Timescale and warnings

Timed modules should declare:

```sv
`timescale 1ns / 1ps
```

If a module lacks a timescale while referenced modules have one, Verilator may emit `TIMESCALEMOD`. Resolve this deliberately:

- add the timescale, or
- disable that specific warning with lint directives, or
- use `-Wno-fatal` only for known non-fatal warnings.

Do not suppress warnings globally to hide real wiring or type errors.

### Test wrappers

A test HDL file should wrap the referenced application module, not copy it:

```sv
module test (...);
  import globals_pkg::*;
  mycore u_mycore (.*);
endmodule
```

The wrapper should expose only the ports needed by the C++ test runner. Avoid duplicating the application module’s implementation.

### Verification

Compile HDL with Verilator and verify port wiring explicitly. A successful Verilator compile does not by itself prove that every port is connected; inspect implicit/explicit port lists and ensure no required port is left unconnected.

## Test and build artifacts

- Do not create generated test artifacts inside `tests/$PROJ` or `tests/$PROJ/src`.
- Do not create `obj_dir`, `test.exe`, generated `.mk` files, or Verilator build products in the source tree.
- Test build output belongs under `out/tests/$PROJ`. The `out/` directory is git-ignored and must not be committed.
- If output is kept inside the repository working tree, it must be excluded from tracked repository content.
- `make clean` should remove generated test output.
- The test source tree should contain only harness source files, not build artifacts.
