#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

[ -z "$1" ] && pinf "usage - $0 <destination_path>\n" && exit

check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && exit
}

if [ "$MB_DISTRO_NAME" = "MINGW64_NT" ]; then
  MB_BOOT_BIN_FP=$(cygpath -m "${MB_BOOT_BIN_FP}")
fi
check_fp MB_BOOT_BIN_FP

cp -v "${MB_BOOT_BIN_FP}" "$1"
