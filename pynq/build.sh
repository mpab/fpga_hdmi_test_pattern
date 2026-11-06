#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

unset FP_ERR
check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && FP_ERR=true
}

info_cp () {
  cp "$1" "$2"
  pinf "copied\n$1\n$2\n"
}

template_cp () {
  pinf "template_cp\n"
  cat "$1" \
  | sed "s|::MB_PROJ_NAME::|${MB_PROJ_NAME}|g" \
  > "$2"
  pinf "copied\n$1\n$2\n"
}

check_fp MB_VIVADO_BIT_FP
check_fp MB_VIVADO_HWH_FP
[ ! -z $FP_ERR ] && exit

mkdir -p "${MB_PYNQ_OUT_PATH}"
info_cp "${MB_VIVADO_BIT_FP}" "${MB_PYNQ_BIT_FP}"
info_cp "${MB_VIVADO_HWH_FP}" "${MB_PYNQ_HWH_FP}"
template_cp "${MB_PYNQ_IPYNB_TEMPLATE_FP}" "${MB_PYNQ_IPYNB_FP}"

REMOTE_HOST_FP="${MB_APP_ROOT}env/host_pynq"
[ ! -f "${REMOTE_HOST_FP}" ] && pwrn "copy/edit\n${MB_PYNQ_PROJ_PATH}host_pynq ->\n${REMOTE_HOST_FP}\n"
exit 0 # pwrn seems to cause a non-zero return, which annoys make
