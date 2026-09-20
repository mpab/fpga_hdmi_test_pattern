VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = "-I${SDL3_DIR}/include"

APP_PATH := $(abspath ../../../)
HDL_SRC_PATH := "$(APP_PATH)/hdl/src"
HDL_SIM_SRC_PATH = $(abspath ../../src)

ifeq ($(OS), Windows_NT)
	SDL_LDFLAGS = -L${SDL3_DIR}/lib -lSDL3 -mconsole
else
	SDL_LDFLAGS = -L${SDL3_DIR}/lib -lSDL3
endif

ifeq ($(BUILD_DIR),)
    BUILD_DIR = "build"
endif

sim: sim.exe

%.exe: %.mk
	make -C ${BUILD_DIR} -f V$<

%.mk: $(HDL_SIM_SRC_PATH)/%.sv
	verilator $(VFLAGS) -Mdir $(BUILD_DIR) -I$(HDL_SRC_PATH) \
	    -cc $< --exe ${HDL_SIM_SRC_PATH}/$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "-std=c++17" \
		-CFLAGS "${SDL_CFLAGS}" \
		-CFLAGS "-D_SDL_USE_VERSION=3" \
		-CFLAGS "-I$(HDL_SIM_SRC_PATH)" \
		-CFLAGS "-I$(HDL_SRC_PATH)" \
		-LDFLAGS "$(SDL_LDFLAGS)"

all: sim
# 	@echo APP_PATH ${APP_PATH}
# 	@echo HDL_SRC_PATH $(HDL_SRC_PATH)
# 	@echo HDL_SIM_SRC_PATH $(HDL_SIM_SRC_PATH)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean