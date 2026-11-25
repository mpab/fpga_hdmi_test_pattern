# Test Project Conventions

## Test project layout

Each test project is a folder named after the project:

```text
tests/$PROJ
```

Examples:

```text
tests/hdl
tests/mister
```

Build output is generated under:

```text
out/tests/$PROJ
```

Do not generate the build output inside `tests/$PROJ/obj_dir`.

## Test harness source files

The test harness components live in:

```text
tests/$PROJ/src/
```

At least two files should be present:

```text
tests/$PROJ/src/test.cpp
tests/$PROJ/src/test.sv
```

or, for Verilog:

```text
tests/$PROJ/src/test.cpp
tests/$PROJ/src/test.v
```

`test.cpp` is the C++ test runner. `test.sv` / `test.v` is the HDL test wrapper.

## Wrapper/Proxy pattern

The HDL test file must wrap the referenced application module. Do not copy the application module into the test source tree.

Example wrapper:

```sv
`timescale 1ns / 1ps

module test (
    input  logic clk,
    input  logic reset,
    input  logic pal,
    input  logic scandouble,
    input  logic [1:0] buttons,
    output logic ce_pix,
    output logic hvcnt_atzero,
    output logic HBlank,
    output logic HSync,
    output logic VBlank,
    output logic VSync,
    output logic [3*globals_pkg::COLOR_BITS-1:0] rgb_data
);
  import globals_pkg::*;

  mycore u_mycore (.*);

endmodule
```

The wrapper should reference the real module through the HDL include path, for example:

```make
-I$(MB_APP_HDL_PATH)
-I$(MB_MISTER_PLATFORM_HDL_PATH)
-I$(TEST_SRC_PATH)
```

This avoids code duplication and code drift between the test harness and the application HDL.

The required convention is that the HDL file wraps the referenced module.

For ports that share the same project-wide names and types, prefer implicit port matching:

```sv
mycore u_mycore (.*);
```

Implicit matching is preferred because any name or type variance is trapped at compile time as an error. It also avoids repeating the full port list and reduces maintenance drift.

Use explicit port connections only where the wrapper must adapt across domains, i.e. where the referenced module’s port names differ from the wrapper’s names:

```sv
video_timing_signals_registered vts (
    .*,
    .beam_at_zero(hvcnt_atzero)
);
```

Explicit mappings are appropriate for cross-domain adapters such as `beam_at_zero` to `hvcnt_atzero`. They should not be the default when the names already match.

The explicit style in `tests/hdl/src/test.sv` is used because that wrapper adapts different domain names/ports; it is not a general rule that all wrappers should list every port explicitly.

## C++ test runners

A C++ runner must drive the wrapper module, not the copied application module.

For a wrapper named `test`, use:

```cpp
#include "Vtest.h"

Vtest hw(&ctx, "TOP");
```

The runner should:

1. Set wrapper inputs.
2. Call `hw.eval()`.
3. Read wrapper outputs.
4. Support useful command-line options such as `--ticks`, `--scandouble`, and `--beam`.

Generated top-module names must match the wrapper name. If the wrapper module is `test`, Verilator generates `Vtest`.

Internal Verilator root access is only for diagnostics and should not replace wrapper ports:

```cpp
hw.rootp->test__DOT__u_mycore__DOT__beam_x
```

Use wrapper outputs where possible. If an internal value is needed, document it as test-only diagnostic access.

## Makefile contract

A test Makefile should capture its paths from `env.mk` and its own location.

Typical structure:

```make
env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))../..)/env.mk
include $(env_mk)

TEST_PATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
TEST_SLUG := $(shell basename $(abspath $(dir $(MAKEFILE_LIST))))
TESTS_OUT_PDIR := $(MB_APP_OUT_PDIR)/tests
OBJ_DIR := $(TESTS_OUT_PDIR)/$(TEST_SLUG)
TEST_SRC_PATH := $(TEST_PATH)src/
```

The Makefile should provide targets such as:

```make
all: test
test: test.exe

clean:
    rm -rf $(OBJ_DIR)

run: test
    $(OBJ_DIR)/test.exe
```

The generated executable is:

```text
out/tests/$PROJ/test.exe
```

## Build commands

From the `tests/` directory:

```sh
make -C hdl
make -C mister
```

From the project root:

```sh
make -C tests/hdl
make -C tests/mister
```

Run targets:

```sh
make -C tests/mister run
```

or directly:

```sh
out/tests/mister/test.exe
```

## SystemVerilog versus Verilog

Use `.sv` for SystemVerilog test wrappers.

Use `.v` for Verilog test sources.

The Makefile rule `%.mk: $(TEST_SRC_PATH)%.sv` assumes a `.sv` source. If the test source is `.v`, adapt the rule to match `.v`, for example:

```make
%.mk: $(TEST_SRC_PATH)%.v
```

The extension should match the language actually used by the source.

## Build artifacts

Generated test artifacts must not be created inside the test source tree:

```text
tests/$PROJ
tests/$PROJ/src
```

Do not create `obj_dir`, `test.exe`, generated `.mk` files, or Verilator build products there.

Generated artifacts belong under:

```text
out/tests/$PROJ
```

`out/` is git-ignored and must not be committed. If output is kept inside the repository working tree, it must remain excluded from tracked repository content.

`make clean` should remove:

```text
out/tests/$PROJ
```

Do not commit generated build artifacts.

## Warnings

Verilator may warn about missing timescales when the wrapper has a timescale and the referenced module does not. This is not a test failure if warnings are made non-fatal:

```make
VFLAGS = -O3 --x-assign fast --x-initial fast --noassert -Wno-fatal
```
