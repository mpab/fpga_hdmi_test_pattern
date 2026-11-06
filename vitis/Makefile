################################################################################
# Vitis makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################

_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

all: create build package

# create fsbl
$(MB_VITIS_FSBL_ELF_FP):
	$(MB_VITIS_PROJ_PATH)create.sh

# build app
$(MB_VITIS_APP_ELF_FP):
	$(MB_VITIS_PROJ_PATH)build.sh

# generate BOOT.bin
$(MB_BOOT_BIN_FP):
	$(MB_VITIS_PROJ_PATH)build-boot-bin.sh

clean:
	rm -rf $(MB_BOOT_BIN_FP)
	rm -rf $(MB_VITIS_TCL_APP_ELF_FP)
	rm -rf $(MB_VITIS_PYTHON_APP_ELF_FP)
	rm -rf $(MB_VITIS_APP_ELF_FP)

distclean:
	$(MB_VITIS_PROJ_PATH)distclean.sh

# utils

.PHONY: create
create: $(MB_VIVADO_XSA_FP) $(MB_VITIS_FSBL_ELF_FP)

.PHONY: build
build: $(MB_VITIS_APP_ELF_FP)

.PHONY: package
package: $(MB_BOOT_BIN_FP)
