###############################################################################
# @file create.tcl
# Author: mpab
# Copyright (c) 2023-, mpab
# All rights reserved.
###############################################################################

# generates the vitis project structure
# generates assets in the vitis project directory
# sources the env script

variable THIS_DIR [file normalize [info script]]
set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
source "${ENV_FP}"

# set the workspace location
setws ./

# ========================================================
# create platform project
puts "creating platform $VITIS_PLATFORM"

platform create -name $VITIS_PLATFORM\
    -hw ${XSA_FILEPATH}\
    -proc {ps7_cortexa9_0} -os {standalone} -out {./}

platform write
#platform generate -domains
::scw::regenerate_psinit $XSA_FILEPATH
#::scw::get_mss_path
#platform active $VITIS_PLATFORM
bsp reload

# +++ 2026.08.16
# throws exception in v2024.2, works in v2023.2
# bsp setlib -name xilffs -ver $XILFFS_VER
# bsp write
# bsp reload
# --- 2026.08.16

catch {bsp regenerate}
platform generate
# ========================================================

# ========================================================
# create application project
puts "creating application ${VITIS_APP}, system ${VITIS_SYSTEM}"

# Open the platform
platform read ${VITIS_PLATFORM}/platform.spr

platform generate

# create C application
# app create -name $VITIS_APP -platform $VITIS_PLATFORM -template {Empty Application(C)} -domain standalone_domain -lang c
puts "app create -name ${VITIS_APP} -platform ${VITIS_PLATFORM} -template {Hello World} -domain standalone_domain -lang c"
app create -name ${VITIS_APP} -platform ${VITIS_PLATFORM} -template {Hello World} -domain standalone_domain -lang c

# BUG: fails if no sources
# import any sources
#importsources -name $VITIS_APP -path ../src/

# ========================================================
# ensure all projects are added to the workspace
importprojects ./
