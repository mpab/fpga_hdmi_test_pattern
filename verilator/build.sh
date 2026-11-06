#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

if [ "$MB_VERILATOR_BUILD_OPT" = "cmake" ]; then
  cd "${MB_VERILATOR_CFG_PATH}" || exit
  cmake -GNinja -S . -B "$MB_VERILATOR_OUT_PATH" -DCMAKE_BUILD_TYPE=Release
  cmake --build "$MB_VERILATOR_OUT_PATH"
elif [ "${MB_VERILATOR_BUILD_OPT}" = "make" ]; then
  cd "${MB_APP_OUT_PDIR}" || exit
  make -f "${MB_VERILATOR_CFG_PATH}Makefile"
else
  perr "unknown value for MB_VERILATOR_BUILD_OPT: $MB_VERILATOR_BUILD_OPT\n"
fi

pinf "verilator build artifacts -> $MB_VERILATOR_OUT_PATH\n"
