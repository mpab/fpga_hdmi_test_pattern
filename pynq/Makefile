################################################################################
# Pynq/Overlay makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################

_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

all: build

# build - generate pynq overlay artifacts
$(MB_PYNQ_BIT_FP):
	$(MB_PYNQ_PROJ_PATH)build.sh
$(MB_PYNQ_HWH_FP):
	$(MB_PYNQ_PROJ_PATH)build.sh
$(MB_PYNQ_IPYNB_FP):
	$(MB_PYNQ_PROJ_PATH)build.sh

clean:
	rm -rf $(MB_PYNQ_BIT_FP)
	rm -rf $(MB_PYNQ_HWH_FP)
	rm -rf $(MB_PYNQ_IPYNB_FP)

distclean: clean
	rm -rf $(MB_PYNQ_OUT_PATH)

build: $(MB_PYNQ_BIT_FP) $(MB_PYNQ_HWH_FP) $(MB_PYNQ_IPYNB_FP)

scp-to-host:
	$(MB_PYNQ_PROJ_PATH)scp-to-host.sh
