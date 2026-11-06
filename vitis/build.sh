#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"
. "${MB_VITIS_PROJ_PATH}utilities.sourcesh"

run_tcl_script () {
  cd "${MB_VITIS_OUT_PATH}" || exit
  vitis_tcl "${1}"
  cp_tcl_artifacts
  exit
}

run_python_script () {
  kill_xilinx
  cd "${MB_APP_OUT_PDIR}" || exit
  pinf "${MB_XILINX_VERSION} - ${1}\n"
  vitis_python "${1}"
  cp_python_artifacts
  exit
}

# use tcl if $MB_TCL_PY_CUTOVER_OPT > $MB_XILINX_VERSION_VAL
build_tcl_if_cutover () {
  [ ${MB_XILINX_VERSION_VAL} -gt ${MB_TCL_PY_CUTOVER_OPT} ] && return
  SCRIPT_FP="${MB_VITIS_PROJ_PATH}build.tcl"
  pinf "${MB_XILINX_VERSION_VAL} < ${MB_TCL_PY_CUTOVER_OPT} - ${SCRIPT_FP}\n"
  run_tcl_script "${SCRIPT_FP}"
}

# attempt to match build-$MB_XILINX_VERSION.py, otherwise use build.py
build_python_version() {
  SCRIPT_FP="${MB_VITIS_PROJ_PATH}build-${MB_XILINX_VERSION}.py"
  [ -f "${SCRIPT_FP}" ] && run_python_script "${SCRIPT_FP}"
  SCRIPT_FP="${MB_VITIS_PROJ_PATH}build.py"
  [ -f "${SCRIPT_FP}" ] && run_python_script "${SCRIPT_FP}"
}

[ ! -f "${MB_VITIS_FSBL_ELF_FP}" ] && perr "missing ${MB_VITIS_FSBL_ELF_FP}\n" && exit

build_tcl_if_cutover
build_python_version
perr "no valid build script\n"
