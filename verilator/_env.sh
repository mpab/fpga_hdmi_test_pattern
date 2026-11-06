#!/usr/bin/env bash
(return 0 2>/dev/null) || { echo "$0 must be sourced"; exit; }

save_env_override() {
  OVERRIDE_MB_VERILATOR_BUILD_OPT="${MB_VERILATOR_BUILD_OPT}"
  OVERRIDE_MB_SDL_VER_OPT="${MB_SDL_VER_OPT}"
}

apply_env_override () {
  # TODO: this is brittle as it only works for script variables
  if [ ! -z "${OVERRIDE_MB_VERILATOR_BUILD_OPT}" ] || [ ! -z "${OVERRIDE_MB_SDL_VER_OPT}" ]; then
    MB_VERILATOR_BUILD_OPT="${OVERRIDE_MB_VERILATOR_BUILD_OPT}"
    MB_SDL_VER_OPT="${OVERRIDE_MB_SDL_VER_OPT}"
    MB_VERILATOR_CFG_PATH="${MB_VERILATOR_PROJ_PATH}sdl${MB_SDL_VER_OPT}/"
    MB_VERILATOR_OUT_DIR="${MB_VERILATOR_OPT}_${MB_VERILATOR_BUILD_OPT}_sdl${MB_SDL_VER_OPT}"
    MB_VERILATOR_OUT_PATH="${MB_APP_OUT_PDIR}/${MB_VERILATOR_OUT_DIR}/"
    MB_VERILATOR_TARGET_FP="${MB_VERILATOR_OUT_PATH}sim"
    MB_VERILATOR_TARGET_EXE_FP="${MB_VERILATOR_OUT_PATH}sim.exe"
    pinf "MB_VERILATOR_BUILD_OPT ${MB_VERILATOR_BUILD_OPT}\n"
    pinf "MB_SDL_VER_OPT ${MB_SDL_VER_OPT}\n"
    pinf "MB_VERILATOR_CFG_PATH ${MB_VERILATOR_CFG_PATH}\n"
    pinf "MB_VERILATOR_OUT_DIR ${MB_VERILATOR_OUT_DIR}\n"
    pinf "MB_VERILATOR_OUT_PATH ${MB_VERILATOR_OUT_PATH}\n"
    pinf "MB_VERILATOR_TARGET_FP ${MB_VERILATOR_TARGET_FP}\n"
    pinf "MB_VERILATOR_TARGET_EXE_FP ${MB_VERILATOR_TARGET_EXE_FP}\n"
    pok "Changed build environment\n"
  fi
}

save_env_override
FP=$(realpath $0) ; PTH=$(dirname $(dirname "${FP}")) ; ENV_SH="${PTH}/env.sh" ; . "${ENV_SH}"
apply_env_override
mkdir -p "${MB_APP_OUT_PDIR}" ; cd "${MB_APP_OUT_PDIR}" || exit
