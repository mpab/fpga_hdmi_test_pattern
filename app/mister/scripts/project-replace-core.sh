#!/usr/bin/env sh

[ -z "$1" ] && echo "usage: $0 new-file-slug" && exit

MISTER_PROJECT_SLUG="$1"

[ ! -d "$MISTER_PROJECT_SLUG" ] && echo "missing folder: $MISTER_PROJECT_SLUG exists" && exit

MYCORE_V="mycore.v"
PROJECT_CORE_SRC="$(dirname $(dirname $(realpath $0)))/src/${MYCORE_V}"
if [ ! -f "$PROJECT_CORE_SRC" ]; then
    echo "ERROR - no source file: $PROJECT_CORE_SRC"
    exit
fi

PROJECT_CORE_DST="${MISTER_PROJECT_SLUG}/rtl/${MYCORE_V}"
if [ ! -f "$PROJECT_CORE_DST" ]; then
    echo "ERROR - no destination file: $PROJECT_CORE_DST"
    exit
fi

if [ ! -f "$PROJECT_CORE_DST-bak" ]; then
    cp "${PROJECT_CORE_DST}" "${PROJECT_CORE_DST}-bak"
fi

CMD="cp ${PROJECT_CORE_SRC} ${PROJECT_CORE_DST}"
echo "${CMD}"
eval "${CMD}"

PROJECT_TOP_SRC="$(dirname $(dirname $(realpath $0)))/src/top.sv"
if [ ! -f "$PROJECT_CORE_SRC" ]; then
    echo "ERROR - no source file: $PROJECT_CORE_SRC"
    exit
fi

PROJECT_TOP_DST="${MISTER_PROJECT_SLUG}/${MISTER_PROJECT_SLUG}.sv"
if [ ! -f "$PROJECT_TOP_DST" ]; then
    echo "ERROR - no destination file: $PROJECT_TOP_DST"
    exit
fi

if [ ! -f "$PROJECT_TOP_DST-bak" ]; then
    cp "${PROJECT_TOP_DST}" "${PROJECT_TOP_DST}-bak"
fi

CMD="cp ${PROJECT_TOP_SRC} ${PROJECT_TOP_DST}"
echo "${CMD}"
eval "${CMD}"
