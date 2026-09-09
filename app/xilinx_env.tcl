###############################################################################
# @file pynq_z2_env.tcl
# Author: mpab
# Copyright (c) 2023-, mpab
# All rights reserved.
###############################################################################

# https://docs.amd.com/r/2023.2-English/ug1400-vitis-embedded/arch
# zynq|zynqmp|fpga|versal
set XILINX_ARCH $::env(XILINX_ARCH)
set XILINX_BOARD $::env(XILINX_BOARD)
set XILINX_BOARD_PART $::env(XILINX_BOARD_PART)
set VIVADO_PROJECT_SLUG $::env(VIVADO_PROJECT_SLUG)
set VIVADO_PROJECT_FOLDER $::env(VIVADO_PROJECT_FOLDER)
set VITIS_PROJECT_SLUG $::env(VITIS_PROJECT_SLUG)
set VITIS_PROJECT_FOLDER $::env(VITIS_PROJECT_FOLDER)
set VIVADO_APP_ROOT $::env(VIVADO_APP_ROOT)
set VITIS_APP_ROOT $::env(VITIS_APP_ROOT)
set VHDL_APP_ROOT $::env(VHDL_APP_ROOT)
set VIVADO_PROJECT_PATH $::env(VIVADO_PROJECT_PATH)
set VITIS_PROJECT_PATH $::env(VITIS_PROJECT_PATH)

# derived/imputed vivado settings
# may change depending on the project
set VIVADO_DESIGN_WRAPPER_SLUG $::env(VIVADO_DESIGN_WRAPPER_SLUG)
set VIVADO_IMPL $::env(VIVADO_IMPL)
set XSA_FILEPATH $::env(XSA_FILEPATH)

# derived/imputed vitis settings
set VITIS_APP $::env(VITIS_APP)
set VITIS_SYSTEM $::env(VITIS_SYSTEM)
set VITIS_PLATFORM $::env(VITIS_PLATFORM)

set BIF_PATH $::env(BIF_PATH)
set BIF_FILEPATH $::env(BIF_FILEPATH)
