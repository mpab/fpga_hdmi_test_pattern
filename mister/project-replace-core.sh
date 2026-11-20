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

TEMPLATE_SV_FP="${MB_MISTER_OUT_PROJ_TEMPLATE_PATH}Template.sv"
if [ ! -f "$TEMPLATE_SV_FP" ]; then
	perr "no template file: $TEMPLATE_SV_FP\n"
	exit
fi

TOP_SV_PATCH_FP="${MB_MISTER_PLATFORM_HDL_PATH}top.sv.patch"
if [ ! -f "$TOP_SV_PATCH_FP" ]; then
	perr "no patch file: $TOP_SV_PATCH_FP\n"
	exit
fi

TOP_SV_FP="${MB_MISTER_OUT_PATH}${MB_MISTER_OPT}.sv"
rm -rf "${TOP_SV_FP}"
cp "${TEMPLATE_SV_FP}" "${TOP_SV_FP}"
patch "${TOP_SV_FP}" "${TOP_SV_PATCH_FP}"
