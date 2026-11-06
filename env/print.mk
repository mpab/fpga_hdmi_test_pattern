_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/_env.mk
include $(_env_mk)

MB_: $(foreach v, $(filter MB_%,$(.VARIABLES)), $(info $(v) $($(v))))

all: MB_
	@echo > /dev/null
