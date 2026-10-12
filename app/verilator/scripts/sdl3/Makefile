MAKEFILE_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = "-I${SDL3_DIR}/include"
SRC_LIBS = $(realpath $(MAKEFILE_DIR)../../../hdl/src)
SIM_SRC = $(realpath $(MAKEFILE_DIR)../../src)

ifeq ($(OS), Windows_NT)
	SDL_LDFLAGS = -L${SDL3_DIR}/lib -lSDL3 -mconsole
else
	SDL_LDFLAGS = -L${SDL3_DIR}/lib -lSDL3
endif

# use build rather than obj_dir to match cmake
ifeq ($(BUILD_DIR),)
    BUILD_DIR = "build"
endif

sim: sim.exe

%.exe: %.mk
	make -C ${BUILD_DIR} -f V$<

%.mk: ${SIM_SRC}/%.sv
	verilator ${VFLAGS} -Mdir ${BUILD_DIR} -I${SRC_LIBS} -I${SIM_SRC} \
	    -cc $< --exe ${SIM_SRC}/$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "-std=c++17" \
		-CFLAGS "${SDL_CFLAGS}" \
		-LDFLAGS "${SDL_LDFLAGS}" \
		-CFLAGS "-D_SDL_USE_VERSION=3"

all: sim

clean:
	rm -rf ${BUILD_DIR}

.PHONY: all clean