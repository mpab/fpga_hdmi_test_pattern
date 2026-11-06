###############################################################################
# @file build.tcl
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
###############################################################################

# generates assets in the vitis output directory

# set standard vars
source [file dirname [info script]]/_env.tcl

# set the workspace location
setws ./

# rebuild platform to fix any 'out of date' warnings
platform active ${MB_VITIS_PLATFORM_OPT}
platform generate

# build application project
# app config -name ${MB_VITIS_APP_OPT} -set build-config release
app build -name ${MB_VITIS_APP_OPT}

# build system project
sysproj build -name ${MB_VITIS_APP_OPT}_system
