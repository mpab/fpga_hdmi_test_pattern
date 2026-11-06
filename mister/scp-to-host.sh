#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

REMOTE_HOST_FP="${MB_APP_ROOT}env/host_mister"

unset FP_ERR
check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && FP_ERR=true
}

check_fp REMOTE_HOST_FP
[ ! -z $FP_ERR ] && exit

REMOTE_HOST=$(cat "${REMOTE_HOST_FP}")
pinf "REMOTE_HOST=${REMOTE_HOST}\n"

# the mister folder structure and default root account
# are standardized, so these paths don't necessarily
# need to be global env vars
MB_MISTER_OVERLAY_PATH="/media/fat/${MB_MISTER_HOST_PROJECT_OPT}/"

ssh "${REMOTE_HOST}" "mkdir -p ${MB_MISTER_OVERLAY_PATH}"
scp "${MB_MISTER_OUT_RBF_FP}" "${REMOTE_HOST}:${MB_MISTER_OVERLAY_PATH}${MB_PROJ_NAME}.rbf"
