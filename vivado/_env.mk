# reset default goal because env recipe will interfere
.DEFAULT_GOAL := all
env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))..)/env.mk
include $(env_mk)
