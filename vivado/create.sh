#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"
echo $PWD

[ -f "${MB_VIVADO_XPR_FP}" ] && pwrn "found ${MB_VIVADO_XPR_FP}\n" && exit
vivado -mode batch -notrace -source "${MB_VIVADO_PROJ_PATH}/create.tcl"  | grep -E 'ERROR:|WARNING:|INFO:|OK:'
