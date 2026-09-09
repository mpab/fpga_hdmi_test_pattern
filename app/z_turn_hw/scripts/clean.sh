#!/usr/bin/env sh

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/z_turn_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

XPR_FP="${VIVADO_PROJECT_FOLDER}/${VIVADO_PROJECT_SLUG}.xpr"
if [ ! -f "${XPR_FP}" ]; then
    echo "ERROR - missing project: ${XPR_FP}"
    exit
fi

cd "${VIVADO_PROJECT_FOLDER}" || exit
rm *.xsa
rm -rf vivado.runs
