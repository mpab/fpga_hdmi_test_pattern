#!/usr/bin/env bash

perr () { printf "\e[1m\e[31mERROR: $1\e[0m"; }
pwrn () { printf "\e[1m\e[33mWARNING: $1\e[0m"; }
pok () { printf "\e[1m\e[32mOK: $1\e[0m"; }
pinf () { printf "\e[1m\e[36mINFO: $1\e[0m"; }

check_path_exp() {
  [ -z "$1" ] && perr "$1 undefined\n" && exit
  FP=$(eval echo $(eval echo "${!1}"))
  [ ! -d "${FP}" ] && perr "invalid $1: ${FP} is not a folder\n" && exit
  pok "$1=$FP\n"
}

check_filepath_exp() {
  [ -z "$1" ] && perr "$1 undefined\n" && exit
  FP=$(eval echo $(eval echo "${!1}"))
  [ ! -f "${FP}" ] && perr "invalid $1: ${FP} is not a file\n" && exit
  pok "$1=$FP\n"
}

[ -z "${XILINX_VERSION}" ] && perr "XILINX_VERSION not set\n" && exit
# [ -z "${XILINX_BOARD_STORE_PATH}" ] && perr "XILINX_BOARD_STORE_PATH not set\n" && exit
# check_path_exp XILINX_BOARD_STORE_PATH

# PLATFORM/ARCHITECTURE SETTINGS
MB_XILINX_PLATFORM_OPT="Pynq-Z2"
MB_XILINX_BOARD_OPT="xc7z020clg400-1"
MB_XILINX_BOARD_PART_OPT="tul.com.tw:pynq-z2:part0:1.0"
MB_XILINX_ARCH_OPT="zynq"
MB_VIVADO_CREATE_USING_BOARD_PART_OPT="1"

# STRUCTURAL SETTINGS
MB_APP_ROOT="$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))/"
MB_PROJ_NAME="$(basename ${MB_APP_ROOT})"
MB_OUT_OPT="out"
MB_APP_OUT_PDIR="\${MB_APP_ROOT}\${MB_OUT_OPT}"
MB_APP_HDL_PATH="\${MB_APP_ROOT}hdl/"
check_path_exp MB_APP_HDL_PATH

# VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO VIVADO
MB_VIVADO_OPT="vivado"
MB_VIVADO_PROJ_PATH="\${MB_APP_ROOT}\${MB_VIVADO_OPT}/"
check_path_exp MB_VIVADO_PROJ_PATH
MB_VIVADO_PLATFORM_DIR="\${MB_APP_ROOT}\${MB_VIVADO_OPT}-${MB_XILINX_PLATFORM_OPT}"
check_path_exp MB_VIVADO_PLATFORM_DIR
MB_VIVADO_PLATFORM_HDL_PATH="\${MB_VIVADO_PLATFORM_DIR}/hdl/"
check_path_exp MB_VIVADO_PLATFORM_HDL_PATH
MB_VIVADO_PLATFORM_DESIGN_TCL_FP="\${MB_VIVADO_PLATFORM_DIR}/tcl/design_1.tcl"
check_filepath_exp MB_VIVADO_PLATFORM_DESIGN_TCL_FP
MB_VIVADO_PLATFORM_XDC_FP="\${MB_VIVADO_PLATFORM_DIR}/constraints/constraints.xdc"
check_filepath_exp MB_VIVADO_PLATFORM_XDC_FP

MB_VIVADO_OUT_DIR="\${MB_XILINX_PLATFORM_OPT}_\${MB_VIVADO_OPT}_\${MB_XILINX_VERSION}"
MB_VIVADO_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_VIVADO_OUT_DIR}/"

MB_VIVADO_BIT_FP="\${MB_APP_OUT_PDIR}/\${MB_VIVADO_OUT_DIR}/${MB_VIVADO_OPT}.runs/impl_1/design_1_wrapper.bit"
MB_VIVADO_HWH_FP="\${MB_APP_OUT_PDIR}/\${MB_VIVADO_OUT_DIR}/${MB_VIVADO_OPT}.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh"
MB_VIVADO_XSA_FP="\${MB_APP_OUT_PDIR}/\${MB_VIVADO_OUT_DIR}/${MB_VIVADO_OPT}.xsa"
MB_VIVADO_XPR_FP="\${MB_APP_OUT_PDIR}/\${MB_VIVADO_OUT_DIR}/${MB_VIVADO_OPT}.xpr"

# when to use python (after v2022.x)
# MB_TCL_PY_CUTOVER_OPT is equivalent to v2023.0
MB_TCL_PY_CUTOVER_OPT="20230"

# VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS VITIS
MB_VITIS_OPT="vitis"
MB_VITIS_PROJ_PDIR="\${MB_APP_ROOT}\${MB_VITIS_OPT}"
MB_VITIS_PROJ_PATH="${MB_VITIS_PROJ_PDIR}/"
check_path_exp MB_VITIS_PROJ_PATH
MB_VITIS_OUT_DIR="\${MB_XILINX_PLATFORM_OPT}_\${MB_VITIS_OPT}_\${MB_XILINX_VERSION}"
MB_VITIS_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_VITIS_OUT_DIR}/"
MB_VITIS_PLATFORM_OPT="platform"
MB_VITIS_PLATFORM_PATH="\${MB_APP_OUT_PDIR}/\${MB_VITIS_OUT_DIR}/\${MB_VITIS_PLATFORM_OPT}/"
MB_VITIS_APP_OPT="app"
MB_VITIS_APP_PATH="\${MB_APP_OUT_PDIR}/\${MB_VITIS_OUT_DIR}/\${MB_VITIS_APP_OPT}/"
MB_VITIS_XPFM_FP="${MB_VITIS_PLATFORM_PATH}export/\${MB_VITIS_PLATFORM_OPT}/\${MB_VITIS_PLATFORM_OPT}.xpfm"

# conform the output file location to simplify create/build
MB_VITIS_FSBL_ELF_FP="${MB_APP_OUT_PDIR}/${MB_VITIS_OUT_DIR}/fsbl.elf"
MB_VITIS_TCL_FSBL_ELF_FP="${MB_VITIS_PLATFORM_PATH}export/\${MB_VITIS_PLATFORM_OPT}/sw/\${MB_VITIS_PLATFORM_OPT}/boot/fsbl.elf"
MB_VITIS_PYTHON_FSBL_ELF_FP="${MB_VITIS_PLATFORM_PATH}export/\${MB_VITIS_PLATFORM_OPT}/sw/boot/fsbl.elf"

# conform the output file location to simplify create/build
MB_VITIS_APP_ELF_FP="${MB_APP_OUT_PDIR}/${MB_VITIS_OUT_DIR}/${MB_VITIS_APP_OPT}.elf"
MB_VITIS_TCL_APP_ELF_FP="${MB_VITIS_APP_PATH}Debug/\${MB_VITIS_APP_OPT}.elf"
MB_VITIS_PYTHON_APP_ELF_FP="${MB_VITIS_APP_PATH}build/\${MB_VITIS_APP_OPT}.elf"

# these need to track each other
MB_VITIS_APP_TCL_TEMPLATE_OPT='Hello World'
MB_VITIS_APP_PYTHON_TEMPLATE_OPT='hello_world'

MB_VITIS_PROJ_SRC_PATH="${MB_VITIS_PROJ_PDIR}/src/"
check_path_exp MB_VITIS_PROJ_SRC_PATH
MB_VITIS_APP_SRC_PATH="\${MB_APP_OUT_PDIR}/\${MB_VITIS_OUT_DIR}/\${MB_VITIS_APP_OPT}/src/"

# BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT BOOT
MB_BOOT_OPT="boot"
MB_BOOT_OUT_DIR="\${MB_XILINX_PLATFORM_OPT}_\${MB_BOOT_OPT}_\${MB_XILINX_VERSION}"
MB_BOOT_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_BOOT_OUT_DIR}/"
MB_BOOT_BIN_FP="\${MB_BOOT_OUT_PATH}BOOT.bin"

# PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ PYNQ
MB_PYNQ_OPT="pynq"
MB_PYNQ_PROJ_PATH="\${MB_APP_ROOT}\${MB_PYNQ_OPT}/"
MB_PYNQ_IPYNB_TEMPLATE_FP="\${MB_PYNQ_PROJ_PATH}\${MB_PYNQ_OPT}.ipynb"
MB_PYNQ_OUT_DIR="\${MB_XILINX_PLATFORM_OPT}_\${MB_PYNQ_OPT}_\${MB_XILINX_VERSION}"
MB_PYNQ_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_PYNQ_OUT_DIR}/"
MB_PYNQ_HWH_FP="\${MB_PYNQ_OUT_PATH}\${MB_PROJ_NAME}.hwh"
MB_PYNQ_BIT_FP="\${MB_PYNQ_OUT_PATH}\${MB_PROJ_NAME}.bit"
MB_PYNQ_IPYNB_FP="\${MB_PYNQ_OUT_PATH}\${MB_PROJ_NAME}.ipynb"

# QUARTUS/MISTER QUARTUS/MISTER QUARTUS/MISTER QUARTUS/MISTER QUARTUS/MISTER QUARTUS/MISTER
MB_MISTER_OPT="mister"
MB_MISTER_TEMPLATE_OPT="Template_MiSTer"
MB_MISTER_HOST_PROJECT_OPT="_PROJECT"
MB_MISTER_PROJ_DIR="\${MB_APP_ROOT}\${MB_MISTER_OPT}"
MB_MISTER_PROJ_PATH="\${MB_MISTER_PROJ_DIR}/"
check_path_exp MB_MISTER_PROJ_PATH
MB_MISTER_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_MISTER_OPT}/"
MB_MISTER_OUT_PROJ_TEMPLATE_PATH="\${MB_APP_OUT_PDIR}/\${MB_MISTER_TEMPLATE_OPT}/"
MB_MISTER_PROJ_QPF_FP="\${MB_MISTER_OUT_PATH}${MB_MISTER_OPT}.qpf"
MB_MISTER_PLATFORM_HDL_PATH="\${MB_MISTER_PROJ_DIR}/hdl/"
check_path_exp MB_MISTER_PLATFORM_HDL_PATH
MB_MISTER_OUT_RTL_PATH="\${MB_APP_OUT_PDIR}/\${MB_MISTER_OPT}/rtl/"
MB_MISTER_OUT_OUTPUT_FILES_PATH="\${MB_APP_OUT_PDIR}/\${MB_MISTER_OPT}/output_files/"
MB_MISTER_OUT_RBF_FP="\${MB_MISTER_OUT_OUTPUT_FILES_PATH}\${MB_MISTER_OPT}.rbf"

# ============================================================================================================
# verilator and sanity checks
check_path_exp VERILATOR_ROOT

MB_VERILATOR_OPT="verilator"

MB_VERILATOR_PROJ_PATH="\${MB_APP_ROOT}\${MB_VERILATOR_OPT}/"
MB_VERILATOR_PROJ_SRC_PATH="${MB_VERILATOR_PROJ_PATH}src/"

check_path_exp MB_VERILATOR_PROJ_PATH
check_path_exp MB_VERILATOR_PROJ_SRC_PATH

[ -z "$MB_VERILATOR_BUILD_OPT" ] && MB_VERILATOR_BUILD_OPT=make && pinf "MB_VERILATOR_BUILD_OPT undefined, defaulting to '$MB_VERILATOR_BUILD_OPT'\n"
[ -z "$MB_SDL_VER_OPT" ] && MB_SDL_VER_OPT=3 && pinf "MB_SDL_VER_OPT undefined, defaulting to '$MB_SDL_VER_OPT'\n"

SDL="SDL${MB_SDL_VER_OPT}"
SDL_DIR="${SDL}_DIR"
check_path_exp "${SDL_DIR}"

MB_VERILATOR_CFG_PATH="${MB_VERILATOR_PROJ_PATH}sdl\${MB_SDL_VER_OPT}/"
check_path_exp MB_VERILATOR_CFG_PATH

MB_VERILATOR_OUT_DIR="\${MB_VERILATOR_OPT}_\${MB_VERILATOR_BUILD_OPT}_sdl\${MB_SDL_VER_OPT}"
MB_VERILATOR_OUT_PATH="\${MB_APP_OUT_PDIR}/\${MB_VERILATOR_OUT_DIR}/"
MB_VERILATOR_TARGET_FP="\${MB_VERILATOR_OUT_PATH}sim"
MB_VERILATOR_TARGET_EXE_FP="\${MB_VERILATOR_OUT_PATH}sim.exe"

# ---------------------------------------------------------------------------------------------------------------

#MB_TEST_PATH="not a path"
# unset MB_APP_ROOT

check_illegal() {
  VNAME="$1"
  VVAL="$2"
  VSTR="$3"
  VMAX="$4"
  MATCHES=$(echo "$VVAL" | grep -o "$VSTR" | wc -l)
  [[ $MATCHES -gt "$VMAX" ]] && perr "$VNAME $MATCHES $VSTR in $VVAL (MAX $VMAX)\n"
}

# layers/priorities
# _OPT
# _DIR  - path fragment without /
# _PDIR - full path without / terminator
# _PATH - full path with / terminator
# _FP
# Each higher priority layer can be composed from lower layers
# Composition should not occur in the same layer

# MB_ILLEGAL_OPT="a/b"
# MB_ILLEGAL_DIR="a/b"
# MB_ILLEGAL_PDIR="a/b/"
# MB_ILLEGAL_PATH="a/b"
# MB_ILLEGAL_FP="a/b/"

generate_env_file() {
  for EV in ${!MB_*}; do
    if [[ $EV == *_OPT ]]; then
      check_illegal "${EV}" "${!EV}" "/" 0
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      check_illegal "${CFG_LINE}" "_OPT"
      echo $CFG_LINE | sed "$4" >> "$3"
    fi
  done

  for EV in ${!MB_*}; do
    if [[ $EV == *_DIR ]]; then
      check_illegal "${EV}" "${!EV}" "/" 0
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      check_illegal "${CFG_LINE}" "_DIR"
      echo $CFG_LINE | sed "$4" >> "$3"
    fi
  done

  for EV in ${!MB_*}; do
    if [[ $EV == *_PDIR ]]; then
      if [[ ${!EV} == */ ]]; then
        perr "illegal path terminator ${EV}=${!EV}\n"
      fi
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      check_illegal "CFG_LINE" "${CFG_LINE}" "_PDIR" 1
      echo $CFG_LINE | sed "$4" >> "$3"
    fi
  done

  for EV in ${!MB_*}; do
    if [[ $EV == *_PATH ]]; then
      if [[ ${!EV} != */ ]]; then
        perr "missing path terminator ${EV}=${!EV}\n"
      fi
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      check_illegal "CFG_LINE" "${CFG_LINE}" "_PATH" 1
      echo $CFG_LINE | sed "$4" >> "$3"
    fi
  done

  for EV in ${!MB_*}; do
    if [[ $EV == *_FP ]]; then
      if [[ ${!EV} == */ ]]; then
        perr "illegal path terminator ${EV}=${!EV}\n"
      fi
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      check_illegal "CFG_LINE" "${CFG_LINE}" "_FP" 1
      echo $CFG_LINE | sed "$4" >> "$3"
    fi
  done

  for EV in ${!MB_*}; do
    if [[ $EV != MB_APP_ROOT ]] && \
       [[ $EV != MB_PROJ_NAME ]] && \
       [[ $EV != *_OPT ]] && \
       [[ $EV != *_DIR ]] && \
       [[ $EV != *_PDIR ]] && \
       [[ $EV != *_PATH ]] && \
       [[ $EV != *_FP ]]; then
      CFG_LINE=$(printf "%s%s%s\"%s\"\n" "$1" "$EV" "$2" "${!EV}")
      pwrn "ignoring $CFG_LINE\n"
    fi
  done
}

ENV_FP=${MB_APP_ROOT}env.sh
if [ ! -f "${ENV_FP}" ]; then
  echo '#!/usr/bin/env bash' >> "${ENV_FP}"
  echo 'perr () { printf "\e[1m\e[31mERROR: $1\e[0m"; }' >> "${ENV_FP}"
  echo 'pwrn () { printf "\e[1m\e[33mWARNING: $1\e[0m"; }' >> "${ENV_FP}"
  echo 'pok () { printf "\e[1m\e[32mOK: $1\e[0m"; }' >> "${ENV_FP}"
  echo 'pinf () { printf "\e[1m\e[36mINFO: $1\e[0m"; }' >> "${ENV_FP}"
  echo '(return 0 2>/dev/null) || { perr "$0 must be sourced\n"; exit; }' >> "${ENV_FP}"
  echo '[ -z "${XILINX_VERSION}" ] && perr "XILINX_VERSION not set\n" && return' >> "${ENV_FP}"
  echo '[ -z "${XILINX_BOARD_STORE_PATH}" ] && perr "XILINX_BOARD_STORE_PATH not set\n" && return' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION="${XILINX_VERSION}"' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION_MAJOR=$(echo "${MB_XILINX_VERSION}" | sed "s/\.[^=&]*//g")' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION_VAL=$(echo "${MB_XILINX_VERSION}" | sed "s/\.//g")' >> "${ENV_FP}"
  echo 'MB_XILINX_BOARD_STORE_PATH="${XILINX_BOARD_STORE_PATH}"' >> "${ENV_FP}"
  echo 'MB_DISTRO_NAME=$(uname -s | sed 's/-.*//')' >> "${ENV_FP}"
  echo 'MB_APP_ROOT="$(dirname $(realpath ${BASH_SOURCE[0]}))/"' >> "${ENV_FP}"
  echo 'MB_PROJ_NAME="$(basename ${MB_APP_ROOT})"' >> "${ENV_FP}"
  generate_env_file '' '=' "${ENV_FP}" 's/^-/-/g'
  pok "created ${ENV_FP}\n"
  chmod +x ${ENV_FP}
else
  pwrn "not overwriting ${ENV_FP}\n"
fi

ENV_FP=${MB_APP_ROOT}env.py
if [ ! -f "${ENV_FP}" ]; then
  echo 'import os' >> "${ENV_FP}"
  echo 'import pathlib' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION = os.getenv("XILINX_VERSION")' >> "${ENV_FP}"
  echo 'MB_XILINX_MAJOR = MB_XILINX_VERSION.split(".")[0]' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION_VAL = MB_XILINX_VERSION.replace(".", "")' >> "${ENV_FP}"
  echo 'MB_XILINX_BOARD_STORE_PATH = os.getenv("XILINX_BOARD_STORE_PATH")' >> "${ENV_FP}"
  echo 'MB_APP_ROOT = f"{pathlib.Path(__file__).resolve().parent.as_posix()}/"' >> "${ENV_FP}"
  echo 'MB_PROJ_NAME = f"{pathlib.Path(MB_APP_ROOT).name}"' >> "${ENV_FP}"
  generate_env_file '' ' = f' "${ENV_FP}" 's/\$//g'
  pok "created ${ENV_FP}\n"
  chmod +x ${ENV_FP}
else
  pwrn "not overwriting ${ENV_FP}\n"
fi

ENV_FP=${MB_APP_ROOT}env.mk
if [ ! -f "${ENV_FP}" ]; then
  echo 'MB_XILINX_VERSION := $(XILINX_VERSION)' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION_MAJOR := $(word 1,$(subst ., ,$(MB_XILINX_VERSION)))' >> "${ENV_FP}"
  echo 'MB_XILINX_VERSION_VAL := $(subst .,,$(MB_XILINX_VERSION))' >> "${ENV_FP}"
  echo 'MB_XILINX_BOARD_STORE_PATH := $(XILINX_BOARD_STORE_PATH)' >> "${ENV_FP}"
  echo 'MB_APP_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))' >> "${ENV_FP}"
  echo 'MB_DISTRO_NAME := $(shell uname -s | sed 's/-.*//')' >> "${ENV_FP}"
  echo 'MB_PROJ_NAME := $(notdir $(patsubst %/,%,$(MB_APP_ROOT)))' >> "${ENV_FP}"
  generate_env_file '' ' := ' "${ENV_FP}" 's/\"//g'
  pok "created ${ENV_FP}\n"
  chmod +x ${ENV_FP}
else
  pwrn "not overwriting ${ENV_FP}\n"
fi

ENV_FP=${MB_APP_ROOT}env.tcl
if [ ! -f "${ENV_FP}" ]; then
  echo 'set MB_XILINX_VERSION $::env(XILINX_VERSION)' >> "${ENV_FP}"
  echo 'set MB_XILINX_VERSION_VAL [string map {"." ""} ${MB_XILINX_VERSION}]' >> "${ENV_FP}"
  echo 'set MB_XILINX_VERSION_MAJOR [lindex [split ${MB_XILINX_VERSION} .] 0]' >> "${ENV_FP}"
  echo 'set MB_XILINX_BOARD_STORE_PATH $::env(XILINX_BOARD_STORE_PATH)' >> "${ENV_FP}"
  echo 'set MB_APP_ROOT "[file dirname [file normalize [info script]]]/"' >> "${ENV_FP}"
  echo 'set MB_PROJ_NAME "[file tail ${MB_APP_ROOT}]"' >> "${ENV_FP}"
  generate_env_file 'set ' ' ' "${ENV_FP}" 's/^-/-/g'
  pok "created ${ENV_FP}\n"
  chmod +x ${ENV_FP}
else
  pwrn "not overwriting ${ENV_FP}\n"
fi
