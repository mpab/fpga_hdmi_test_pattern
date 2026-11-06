################################################################################
# Mister makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################

_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

all: create build

# create (project)
$(MB_MISTER_PROJ_QPF_FP):
	$(MB_MISTER_PROJ_PATH)create.sh

# build
$(MB_MISTER_OUT_RBF_FP):
	$(MB_MISTER_PROJ_PATH)build.sh

clean:
	$(MB_MISTER_PROJ_PATH)clean.sh

distclean: clean
	rm -rf $(MB_MISTER_OUT_PATH)

.PHONY: create
create: $(MB_MISTER_PROJ_QPF_FP)

.PHONY: build
build: create $(MB_MISTER_OUT_RBF_FP)
