# Backlog

## Done

- [x] Refactor layout with all generated/temporary assets in ./out
- [x] Add prefix to all env-vars
- [x] Support low and high cutover thresholds for tcl/python
- [x] Use scripts for functionality, Makefiles for dependency management and triggering
- [x] Generate env settings for shell scripts, python and makefile from a single source
- Xilinx
  - [x] Support multiple versions
  - [x] Support PYNQ overlay
  - [x] Scope output by xilinx version - e.g. vitis_20232
  - [x] Support scp to Xilinx PYNQ target
- MiSTer
  - [x] Support mister target
  - [x] Support scp to MiSTer target
- Testing
- [x] ./hdl: Implement basic test runner
- [x] ./hdl: support test configuration
- [x] ./hdl: support test reports (markdown)
- [x] ./mister: Implement basic test runner

## Maybe

- Xilinx
  - [x] Reinstate bitstream programming
  - [ ] Support multiple Xilinx platforms (Pynq-Z2, Z-turn, ...)
- MiSTer
  - [ ] Detect display resolution
- Gowin
  - [ ] Support Tang Nano 20K

## Todo

- Testing
- [ ] ./mister: support test configuration
  - Add `tests/mister/src/test.py` as the validation driver.
  - Refactor `tests/mister/src/test.cpp` so it only forwards wrapper inputs and emits raw model output.
  - Add expected configuration files under `tests/mister/test_data/`:
    - `expected_samples.csv`
    - `expected_reset.csv`
  - Add `TEST_DATA_PATH := $(TEST_PATH)test_data/` to `tests/mister/Makefile`.
  - Update the `run` target to invoke:
    ```make
    python3 $(TEST_SRC_PATH)test.py $(TEST_DATA_PATH)
    ```
  - Acceptance: `make -C tests/mister run` prints `PASS` or `FAIL` and returns the correct exit status.

- [ ] ./mister: support test reports (markdown)
  - Have `test.py` write `out/tests/mister/results.md`.
  - Include:
    - overall status
    - check/failure counts
    - sample-group table
    - reset-check table
    - failure-detail table
  - Acceptance: `out/tests/mister/results.md` exists after `make -C tests/mister run` and its tables match the validation result.
