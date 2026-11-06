#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; ENV_SH="${PTH}/env.sh" ; . "${ENV_SH}"

XILINX_CMD=$(command -v xilinx)
[ -z "${XILINX_CMD}" ] && perr "xilinx utility is required to run this script\n" && exit

check_build () {
  . xilinx-use "$1" >/dev/null
  CI_LOG="${MB_APP_OUT_PDIR}/$0-$1.log"
  rm -rf "${CI_LOG}"
  VIV_LOG="${MB_APP_OUT_PDIR}/vivado.log"
  rm -rf "${VIV_LOG}"
  make -f xilinx.mk clean >/dev/null
  pinf "building $1\n"
  make -f xilinx.mk > "${CI_LOG}" 2>&1

  [ ! -f "${VIV_LOG}" ] && perr "building $1 - no log ${VIV_LOG}\n" && return
  [ ! -f "${CI_LOG}" ] && perr "building $1 - no log ${CI_LOG}\n" && return

  cat "${VIV_LOG}" >> "${CI_LOG}"
  if grep -q ERROR: "${CI_LOG}"; then
    perr "building $1\n"
  else
    pok "built $1\n"
  fi
}

mkdir -p "${MB_APP_OUT_PDIR}"
check_build 2022.2
check_build 2023.2
check_build 2024.2
check_build 2025.2
