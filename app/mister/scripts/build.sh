#!/usr/bin/env sh

ENV_FP="$(dirname $(realpath $0))/mister_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

PROJECT_QPF="./${QUARTUS_PROJECT_NAME}/${QUARTUS_PROJECT_NAME}.qpf"
if [ ! -f "${PROJECT_QPF}" ]; then
    echo "ERROR - no project: ${PROJECT_QPF}"
    exit
fi

SCRIPTS_PATH="$(dirname $(realpath $0))"
. "${SCRIPTS_PATH}/__mister_config"

cd "${QUARTUS_PROJECT_NAME}" || exit
quartus_sh --flow compile "${QUARTUS_PROJECT_NAME}"
