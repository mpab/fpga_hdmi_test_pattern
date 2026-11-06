#!/usr/bin/env bash
(return 0 2>/dev/null) || { echo "$0 must be sourced"; exit; }
FP=$(realpath $0) ; PTH=$(dirname $(dirname "${FP}")) ; ENV_SH="${PTH}/env.sh" ; . "${ENV_SH}"
mkdir -p "${MB_APP_OUT_PDIR}" ; cd "${MB_APP_OUT_PDIR}" || exit
