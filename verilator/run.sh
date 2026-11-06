#!/usr/bin/env sh
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

cd "${MB_APP_HDL_PATH}" || exit

if [ -f "${MB_VERILATOR_TARGET_FP}" ]; then
  pinf "run ${MB_VERILATOR_TARGET_FP}\n"
  "${MB_VERILATOR_TARGET_FP}"
  exit
elif [ -f "${MB_VERILATOR_TARGET_EXE_FP}" ]; then
  pinf "run ${MB_VERILATOR_TARGET_EXE_FP}\n"
  "${MB_VERILATOR_TARGET_EXE_FP}"
  exit
fi

pwrn "build first\n"
