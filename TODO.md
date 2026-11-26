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
  - [x] ./mister: support test configuration
  - [x] ./mister: support test reports (markdown)

## Maybe

- Xilinx
  - [x] Reinstate bitstream programming
  - [ ] Support multiple Xilinx platforms (Pynq-Z2, Z-turn, ...)
- MiSTer
  - [ ] Detect display resolution
- Gowin
  - [ ] Support Tang Nano 20K
- Add pre check-in hooks
  - [ ] formatting
  - [ ] code review
  - [ ] linting
  - [ ] tests

## Todo
