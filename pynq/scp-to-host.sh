#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

REMOTE_HOST_FP="${MB_APP_ROOT}env/host_pynq"

unset FP_ERR
check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && FP_ERR=true
}

check_fp REMOTE_HOST_FP
check_fp MB_PYNQ_BIT_FP
check_fp MB_PYNQ_HWH_FP
check_fp MB_PYNQ_IPYNB_FP
[ ! -z $FP_ERR ] && exit

REMOTE_HOST=$(cat "${REMOTE_HOST_FP}")
pinf "REMOTE_HOST=${REMOTE_HOST}\n"

# the pyng folder structure and default xilinx account
# are standardized, so these paths don't necessarily
# need to be global env vars
MB_PYNQ_OVERLAY_PATH="/home/xilinx/pynq/overlays/${MB_PROJ_NAME}/"
MB_PYNQ_JUPYTER_NOTEBOOKS_PATH="/home/xilinx/jupyter_notebooks/"

ssh "${REMOTE_HOST}" "mkdir -p ${MB_PYNQ_OVERLAY_PATH}"
scp "${MB_PYNQ_BIT_FP}" "${REMOTE_HOST}:${MB_PYNQ_OVERLAY_PATH}"
scp "${MB_PYNQ_HWH_FP}" "${REMOTE_HOST}:${MB_PYNQ_OVERLAY_PATH}"
scp "${MB_PYNQ_IPYNB_FP}" "${REMOTE_HOST}:${MB_PYNQ_JUPYTER_NOTEBOOKS_PATH}"
