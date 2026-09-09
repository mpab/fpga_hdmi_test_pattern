#!/usr/bin/env sh

[ -z "$1" ] && echo "usage: $0 <path or disk label>" && exit

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/pynq_z2_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

if [ -d "$1" ]; then
    EXEC="cp ${VITIS_PROJECT_FOLDER}/vitis_app_system/_ide/bootimage/BOOT.bin ${1}/."
    echo "${EXEC}"
    ${EXEC}
    exit
fi

echo "invalid destination $1"