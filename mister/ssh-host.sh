#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

REMOTE_HOST_FP="${MB_APP_ROOT}env/host_mister"

unset FP_ERR
check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && FP_ERR=true
}
check_fp REMOTE_HOST_FP

REMOTE_HOST=$(cat "${REMOTE_HOST_FP}")
pinf "REMOTE_HOST=${REMOTE_HOST}\n"
ssh "${REMOTE_HOST}"
