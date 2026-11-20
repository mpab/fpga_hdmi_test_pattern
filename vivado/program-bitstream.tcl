source [file dirname [info script]]/_env.tcl

open_project "${MB_VIVADO_XPR_FP}"
set_param general.maxThreads 8

open_hw_manager
connect_hw_server
current_hw_target
open_hw_target
set_property PROGRAM.FILE "${MB_VIVADO_BIT_FP}" [current_hw_device]
program_hw_devices [current_hw_device]
