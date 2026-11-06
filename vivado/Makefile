################################################################################
# Vivado makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################

_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

all: create build

# create (project)
$(MB_VIVADO_XPR_FP):
	$(MB_VIVADO_PROJ_PATH)create.sh

# build
$(MB_VIVADO_XSA_FP):
	$(MB_VIVADO_PROJ_PATH)build.sh
$(MB_VIVADO_BIT_FP):
	$(MB_VIVADO_PROJ_PATH)build.sh

clean:
	rm -rf $(MB_VIVADO_XSA_FP)
	rm -rf $(MB_VIVADO_BIT_FP)

distclean: clean
	rm -rf $(MB_VIVADO_OUT_PATH)
	rm -rf $(MB_APP_OUT_PDIR)/*.log
	rm -rf $(MB_APP_OUT_PDIR)/*.jou
	rm -rf $(MB_APP_OUT_PDIR)/.Xil
	rm -rf $(MB_APP_OUT_PDIR)/NA
	rm -rf $(MB_APP_OUT_PDIR)/*.txt

.PHONY: create
create: $(MB_VIVADO_XPR_FP)

.PHONY: build
build: $(MB_VIVADO_XPR_FP) $(MB_VIVADO_XSA_FP) $(MB_VIVADO_BIT_FP)
