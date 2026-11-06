#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

[ ! -f "${MB_VIVADO_XPR_FP}" ] && perr "missing ${MB_VIVADO_XPR_FP}\n" && exit
vivado -mode batch -notrace -source "${MB_VIVADO_PROJ_PATH}/build.tcl" | grep -E 'ERROR:|WARNING:|INFO:|OK:'
