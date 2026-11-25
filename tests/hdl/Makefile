env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))../..)/env.mk
include $(env_mk)

VFLAGS = -O3 --x-assign fast --x-initial fast --noassert -Wno-fatal
CFLAGS = -std=c++17 -D_GLIBCXX_USE_CXX11_ABI=0 -O3 -DNDEBUG

TEST_PATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
TEST_SLUG := $(shell basename $(abspath $(dir $(MAKEFILE_LIST))))
TESTS_OUT_PDIR := $(MB_APP_OUT_PDIR)/tests
OBJ_DIR := $(TESTS_OUT_PDIR)/$(TEST_SLUG)
TEST_SRC_PATH := $(TEST_PATH)src/
TEST_DATA_PATH := $(TEST_PATH)test_data/

test: test.exe

%.exe: %.mk
	make -C $(OBJ_DIR) -f V$<

%.mk: $(TEST_SRC_PATH)%.sv
	mkdir -p $(TESTS_OUT_PDIR)
	verilator $(VFLAGS) -Mdir $(OBJ_DIR) -I$(MB_APP_HDL_PATH) -I$(TEST_SRC_PATH) \
		-cc $< --exe $(TEST_SRC_PATH)$*.cpp -o $*.exe \
		-CFLAGS "$(CFLAGS)"

all: test

clean:
	rm -rf $(OBJ_DIR)

run: test
	python3 $(TEST_SRC_PATH)test.py $(TEST_DATA_PATH)

.PHONY: all clean
