#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

cd "${MB_MISTER_OUT_PATH}" || exit

safe_cp() {
  [ ! -f "$1" ] && pwrn "no source\n $1\n" && return
  rm -rf "$2"
  [ -f "$2" ] && perr "failed to remove target\n $2\n" && return
  cp "$1" "$2"
  pinf "copied\n $1\n $2\n"
}

MYCORE_V="mycore.v"
PROJECT_CORE_SRC="${MB_MISTER_PLATFORM_HDL_PATH}${MYCORE_V}"
if [ ! -f "$PROJECT_CORE_SRC" ]; then
    perr "no source file: $PROJECT_CORE_SRC\n"
    exit
fi

PROJECT_CORE_DST="${MB_MISTER_OUT_RTL_PATH}${MYCORE_V}"
if [ ! -f "$PROJECT_CORE_DST" ]; then
    perr "no destination file: $PROJECT_CORE_DST\n"
    exit
fi

if [ ! -f "$PROJECT_CORE_DST-bak" ]; then
    safe_cp "${PROJECT_CORE_DST}" "${PROJECT_CORE_DST}-bak"
fi
safe_cp "${PROJECT_CORE_SRC}" "${PROJECT_CORE_DST}"

PROJECT_TOP_SRC="${MB_MISTER_PLATFORM_HDL_PATH}top.sv"
if [ ! -f "$PROJECT_TOP_SRC" ]; then
    perr "no source file: $PROJECT_TOP_SRC\n"
    exit
fi

PROJECT_TOP_DST="${MB_MISTER_OUT_PATH}${MB_MISTER_OPT}.sv"
if [ ! -f "$PROJECT_TOP_DST" ]; then
    perr "no destination file: $PROJECT_TOP_DST\n"
    exit
fi

if [ ! -f "$PROJECT_TOP_DST-bak" ]; then
    safe_cp "${PROJECT_TOP_DST}" "${PROJECT_TOP_DST}-bak"
fi
safe_cp "${PROJECT_TOP_SRC}" "${PROJECT_TOP_DST}"
