VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SRC_LIBS = ../../hardware/src
SIM_SRC = ../../src

ifeq ($(OS), Windows_NT)
	SDL_LDFLAGS = `sdl2-config --libs` -mconsole
else
	SDL_LDFLAGS = `sdl2-config --libs`
endif

ifeq ($(BUILD_DIR),)
    BUILD_DIR = "build"
endif

sim: sim.exe

%.exe: %.mk
	make -C ${BUILD_DIR} -f V$<

%.mk: ../src/%.sv
	verilator ${VFLAGS} -Mdir ${BUILD_DIR} -I${SRC_LIBS} \
	    -cc $< --exe ${SIM_SRC}/$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "-std=c++17" \
		-CFLAGS "${SDL_CFLAGS}" \
		-CFLAGS "-D_SDL_USE_VERSION=2" \
		-CFLAGS "-I${SIM_SRC}" \
		-LDFLAGS "${SDL_LDFLAGS}"

all: sim

clean:
	rm -rf ${BUILD_DIR}

.PHONY: all clean