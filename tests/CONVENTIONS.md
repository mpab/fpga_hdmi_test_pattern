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

Test harness source files use the `test` stem consistently:

```text
tests/$PROJ/src/test.py
tests/$PROJ/src/test.cpp
tests/$PROJ/src/test.sv
```

or, for Verilog:

```text
tests/$PROJ/src/test.py
tests/$PROJ/src/test.cpp
tests/$PROJ/src/test.v
```

`test.cpp` is the C++ forwarding runner. `test.sv` / `test.v` is the HDL test wrapper. `test.py` is the Python validation driver.

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

`tests/hdl/src/test.sv` uses implicit `.*` matching for both wrapped modules because their port names and types match the wrapper ports. Explicit mapping is reserved for cross-domain adapters.

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

## Configuration-driven test validation

The test harness separates model driving from test validation.

The HDL wrapper, such as `tests/$PROJ/src/test.sv`, wraps the application module and exposes the wrapper ports. It does not contain test data or expected values.

The C++ runner, such as `tests/$PROJ/src/test.cpp`, is a thin forwarding driver. It:

- Sets wrapper inputs from command-line arguments such as `--res`, `--pattern`, and `--ticks`.
- Calls `hw.eval()` to advance the wrapper model.
- Prints raw model output rows in a fixed field order.
- Optionally prints the reset state with `--reset`.

The C++ runner does not load expected data, decide PASS/FAIL, or contain test policy.

The Python driver, such as `tests/$PROJ/src/test.py`, owns the test configuration and validation. It:

- Loads expected configuration from CSV files under `tests/$PROJ/test_data/`.
- Groups sample rows by resolution and pattern, e.g. `(res_sel, pattern_sel)`.
- Invokes `test.exe` with the required tick list for each group.
- Compares the returned model fields against the expected fields.
- Checks reset-state rows separately.
- Prints detailed mismatches and a final `PASS` or `FAIL` line.
- Returns a non-zero exit status when validation fails.
- Writes a Markdown results report to `out/tests/$PROJ/results.md`.

Expected test data belongs in configuration files, not inside the HDL wrapper or C++ runner:

```text
tests/$PROJ/test_data/expected_samples.csv
tests/$PROJ/test_data/expected_reset.csv
```

These CSV files are source configuration, not generated build artifacts. Each sample should include the selector values, the tick, and the wrapper output fields being checked. A useful sample set is about ten ticks per `(res_sel, pattern_sel)` combination, including signal transition ticks and at least one pattern-specific tick.

The separation of responsibilities is deliberate:

- HDL defines the model and wrapper ports.
- C++ drives the wrapper and emits raw output.
- Python handles file loading, CSV comparison, grouping, reporting, and exit status.

This keeps validation logic in a language suited to CSV and file manipulation, while the C++ runner remains focused on the Verilated model interface.

Review criteria:

- `test.cpp` should not contain expected values or PASS/FAIL policy.
- `test.py` should be the sole validation authority.
- Expected CSV files should be grouped consistently by resolution and pattern.
- Tick order should be deterministic.
- Reset checks should compare the intentional reset-state outputs.
- The Makefile `run` target should invoke the Python driver, not only the executable.
- Generated build artifacts should remain under `out/tests/$PROJ`.

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
TEST_DATA_PATH := $(TEST_PATH)test_data/
```

The Makefile should provide targets such as:

```make
all: test
test: test.exe

clean:
    rm -rf $(OBJ_DIR)

run: test
    python3 $(TEST_SRC_PATH)test.py $(TEST_DATA_PATH)
```

The generated executable is:

```text
out/tests/$PROJ/test.exe
```

The Python driver also writes a Markdown results report:

```text
out/tests/$PROJ/results.md
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

The direct executable prints raw model output. It does not load expected configuration or perform PASS/FAIL validation. Use the `run` target for validation:

```sh
make -C tests/hdl run
make -C tests/mister run
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
