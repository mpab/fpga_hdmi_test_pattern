###############################################################################
# @file create.tcl
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
###############################################################################

# generates the vitis project structure
# generates assets in the vitis project directory
# sources the env script

# set standard vars
source [file dirname [info script]]/_env.tcl

# set the workspace location
setws ./

# ========================================================
# create platform project
platform create -name $MB_VITIS_PLATFORM_OPT\
    -hw ${MB_VIVADO_XSA_FP}\
    -proc {ps7_cortexa9_0} -os {standalone} -out {./}

platform write
#platform generate -domains
::scw::regenerate_psinit $MB_VIVADO_XSA_FP
#::scw::get_mss_path
#platform active $MB_VITIS_PLATFORM_OPT
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

# Open the platform
#platform read ${MB_VITIS_PLATFORM_OPT}/platform.spr
#platform generate

# create C application
# app create -name $VITIS_APP -platform $VITIS_PLATFORM -template {Empty Application(C)} -domain standalone_domain -lang c
puts "app create -name ${MB_VITIS_APP_OPT} -platform ${MB_VITIS_PLATFORM_OPT} -template ${MB_VITIS_APP_TCL_TEMPLATE_OPT} -domain standalone_domain -lang c"
app create -name ${MB_VITIS_APP_OPT} -platform ${MB_VITIS_PLATFORM_OPT} -template ${MB_VITIS_APP_TCL_TEMPLATE_OPT} -domain standalone_domain -lang c

# BUG: fails if no sources
# import any sources
importsources -name ${MB_VITIS_APP_OPT} -path ${MB_VITIS_PROJ_SRC_PATH}

# ========================================================
# ensure all projects are added to the workspace
importprojects ./
