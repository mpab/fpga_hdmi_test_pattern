#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

[ ! -f "${MB_MISTER_PROJ_QPF_FP}" ] && perr "missing project: ${MB_MISTER_PROJ_QPF_FP}\n" && exit

QUARTUS_SH=$(command -v quartus_sh)
[ -z "${QUARTUS_SH}" ] && perr "quartus_sh required to build\n" && exit

cd "${MB_MISTER_OUT_PATH}" || exit
quartus_sh --flow compile "${MB_MISTER_OPT}.qpf"

REMOTE_HOST_FP="${MB_APP_ROOT}env/host_mister"
[ ! -f "${REMOTE_HOST_FP}" ] && pwrn "copy/edit\n${MB_PYNQ_PROJ_PATH}host_mister ->\n${REMOTE_HOST_FP}\n"
exit 0 # pwrn seems to cause a non-zero return, which annoys make
