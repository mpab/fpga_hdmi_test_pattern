#!/usr/bin/make -f
MAKE_SELF := $(notdir $(MAKE)) -f $(lastword $(MAKEFILE_LIST))
################################################################################
# FPGA application makefile
# Author: mpab
# Copyright (c) 2026-, mpab
# All rights reserved.
#
################################################################################
env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/env.mk
include $(env_mk)

PROJ_DIRS := vivado vitis
.PHONY: $(PROJ_DIRS)
all: $(PROJ_DIRS)

$(PROJ_DIRS):
	$(MAKE) -C $@

ALLDIRS := . $(wildcard */.)

########################################################################
############################# Targets ##################################
########################################################################

##@ Targets

tidy: ## delete all none-build artifacts (log files, etc.) in $(ALLDIRS)
	@for dir in $(ALLDIRS); do \
		echo tidy $$dir ; \
		rm -rf $$dir/__pycache__ ; \
		rm -rf $$dir/*.log ; \
		rm -rf $$dir/*.jou ; \
		rm -rf $$dir/.Xil ; \
		rm -rf $$dir/NA ; \
		rm -rf $$dir/dfx_runtime.txt ; \
	done

clean: ## clean $(PROJ_DIRS)
	for dir in $(PROJ_DIRS); do \
	    $(MAKE) -C $$dir clean; \
	done

distclean: tidy ## tidy and distclean $(PROJ_DIRS)
	for dir in $(PROJ_DIRS); do \
	    $(MAKE) -C $$dir distclean; \
	done

##@ Help commands

.PHONY: readme
readme: ## view README.md using leaf
	leaf ./README.md

.PHONY: help
help: ## display this help
	@awk 'BEGIN {FS = ":.*##";                                            		\
		printf "Usage: $(MAKE_SELF) \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ 	\
		{ printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/            	\
		{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } '                  	\
		$(MAKEFILE_LIST)
