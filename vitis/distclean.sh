#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"
. "${MB_VITIS_PROJ_PATH}utilities.sourcesh"

kill_xilinx_if_cutover
rm -rf ${MB_BOOT_OUT_PATH}
rm -rf ${MB_VITIS_OUT_PATH}
