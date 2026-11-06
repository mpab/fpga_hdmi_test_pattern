#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

if [ ! -d "${MB_MISTER_OUT_PROJ_TEMPLATE_PATH}" ]; then
    git clone "https://github.com/MiSTer-devel/${MB_MISTER_TEMPLATE_OPT}"
else
    cd "${MB_MISTER_OUT_PROJ_TEMPLATE_PATH}" || exit
    git pull
fi
