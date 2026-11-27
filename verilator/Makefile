################################################################################
# Verilator makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################

_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

all: build

# build target
$(MB_VERILATOR_TARGET_FP):
	@$(MB_VERILATOR_PROJ_PATH)build.sh

clean:
	@$(MB_VERILATOR_PROJ_PATH)clean.sh

.PHONY: build
build: $(MB_VERILATOR_TARGET_FP)

.PHONY: run
run:
	@$(MB_VERILATOR_PROJ_PATH)run.sh
