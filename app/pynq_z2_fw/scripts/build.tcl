###############################################################################
# @file build.tcl
# Author: mpab
# Copyright (c) 2023-, mpab
# All rights reserved.
###############################################################################

# generates assets in the vitis project directory
# sources the env script

variable THIS_DIR [file normalize [info script]]
set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
source "${ENV_FP}"

# set the workspace location
setws ./

# ========================================================
# fix $PROJ_app_system.bif -> BOOT.bin issue

# template
# "//arch = zynq; split = false; format = BIN
# the_ROM_image:
# {
#     [bootloader]$VIV_PROJ_DIR/pynq_z2_pfm/export/pynq_z2_pfm/sw/pynq_z2_pfm/boot/fsbl.elf
#     ${PROJECT_ROOT}/hardware/vivado/vivado.runs/${VIVADO_IMPL}/design_1_wrapper.bit
#     $VIV_PROJ_DIR/hdmi_overlay_app/Debug/$VITIS_APP.elf
# }"

file mkdir $BIF_PATH

set FH [open "$BIF_FILEPATH" w]
puts $FH "//arch = $XILINX_ARCH; split = false; format = BIN"
puts $FH "the_ROM_image:"
puts $FH "{"
puts $FH "    \[bootloader\]${VITIS_PROJECT_PATH}/${VITIS_PLATFORM}/export/${VITIS_PLATFORM}/sw/${VITIS_PLATFORM}/boot/fsbl.elf"
puts $FH "    ${VIVADO_PROJECT_PATH}/${VIVADO_PROJECT_SLUG}.runs/${VIVADO_IMPL}/${VIVADO_DESIGN_WRAPPER_SLUG}.bit"
puts $FH "    ${VITIS_PROJECT_PATH}/${VITIS_APP}/Debug/${VITIS_APP}.elf"
puts $FH "}"
close $FH

puts "created $BIF_FILEPATH"

# ========================================================

# rebuild platform to fix 'out of date' warning
platform active $VITIS_PLATFORM
platform generate

# build application project
app build -name ${VITIS_APP}

# build system project
sysproj build -name ${VITIS_SYSTEM}

# generate BOOT.bin
exec bootgen -arch ${XILINX_ARCH} -image ${BIF_FILEPATH} -w -o ${BIF_PATH}/BOOT.bin
puts "created ${BIF_PATH}/BOOT.bin"
