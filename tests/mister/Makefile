env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))../..)/env.mk
include $(env_mk)

VFLAGS = -O3 --x-assign fast --x-initial fast --noassert -Wno-fatal
CFLAGS = -std=c++17 -O3 -DNDEBUG

TEST_PATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
TEST_SLUG := $(shell basename $(abspath $(dir $(MAKEFILE_LIST))))
TESTS_OUT_PDIR := $(MB_APP_OUT_PDIR)/tests
OBJ_DIR := $(TESTS_OUT_PDIR)/$(TEST_SLUG)
TEST_SRC_PATH := $(TEST_PATH)src/

test: test.exe

%.exe: %.mk
	make -C $(OBJ_DIR) -f V$<

%.mk: $(TEST_SRC_PATH)%.sv
	mkdir -p $(TESTS_OUT_PDIR)
	verilator $(VFLAGS) -Mdir $(OBJ_DIR) -I$(MB_APP_HDL_PATH) -I$(MB_MISTER_PLATFORM_HDL_PATH) -I$(TEST_SRC_PATH) \
	    -cc $< --exe $(TEST_SRC_PATH)$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "$(CFLAGS)"

all: test

clean:
	rm -rf $(OBJ_DIR)

run: test
	$(OBJ_DIR)/test.exe

.PHONY: all clean