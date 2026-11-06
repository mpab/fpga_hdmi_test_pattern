_env_mk := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))..)/_env.mk
include $(_env_mk)

VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = "-I${SDL3_DIR}/include"

ifeq ($(OS), Windows_NT)
	SDL_LDFLAGS = -L$(SDL3_DIR)/lib -lSDL3 -mconsole
else
	SDL_LDFLAGS = -L$(SDL3_DIR)/lib -lSDL3
endif

MB_VERILATOR_OUT_DIR := $(MB_VERILATOR_OPT)_make_sdl3

sim: sim.exe

%.exe: %.mk
	make -C $(MB_VERILATOR_OUT_DIR) -f V$<

%.mk: $(MB_VERILATOR_PROJ_SRC_PATH)%.sv
	verilator $(VFLAGS) -Mdir $(MB_VERILATOR_OUT_DIR) -I$(MB_APP_HDL_PATH) -I$(MB_VERILATOR_PROJ_SRC_PATH) \
	    -cc $< --exe $(MB_VERILATOR_PROJ_SRC_PATH)$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "-std=c++17" \
		-CFLAGS "$(SDL_CFLAGS)" \
		-LDFLAGS "$(SDL_LDFLAGS)" \
		-CFLAGS -O3 -DNDEBUG \
		-CFLAGS -DMB_SDL_VER_OPT=3

all: sim

clean:
	rm -rf $(MB_VERILATOR_OUT_DIR)

.PHONY: all clean