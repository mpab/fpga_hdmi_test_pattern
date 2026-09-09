#!/usr/bin/env sh

ENV_FP="$(dirname $(realpath $0))/mister_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

PROJECT_QPF="./${QUARTUS_PROJECT_NAME}/${QUARTUS_PROJECT_NAME}.qpf"
if [ -f "${PROJECT_QPF}" ]; then
    echo "WARNING - existing project: ${PROJECT_QPF}.qpf"
    exit
fi

SCRIPTS_PATH="$(dirname $(realpath $0))"

check_filepath () {
    if [ ! -f "$1" ]; then
        echo "ERROR - no file: $1"
        exit
    fi
}

MISTER_CONFIG="${SCRIPTS_PATH}/__mister_config"
check_filepath "${MISTER_CONFIG}"
. "${MISTER_CONFIG}"

PROJECT_CLONE="${SCRIPTS_PATH}/project-clone.sh"
check_filepath "${PROJECT_CLONE}"

PROJECT_RENAME_REFERENCES="${SCRIPTS_PATH}/project-rename-references.sh"
check_filepath "${PROJECT_RENAME_REFERENCES}"

PROJECT_APPEND_APPLICATION_QIP="${SCRIPTS_PATH}/project-append-application-qip.sh"
check_filepath "${PROJECT_APPEND_APPLICATION_QIP}"

PROJECT_COPY_CORE="${SCRIPTS_PATH}/project-replace-core.sh"
check_filepath "${PROJECT_COPY_CORE}"

"$PROJECT_CLONE" "${QUARTUS_PROJECT_NAME}"
THIS_DIR="${PWD}"
cd "${QUARTUS_PROJECT_NAME}"
"$PROJECT_RENAME_REFERENCES" "${QUARTUS_PROJECT_NAME}"
cd "${THIS_DIR}"
"$PROJECT_APPEND_APPLICATION_QIP" "${QUARTUS_PROJECT_NAME}"
"$PROJECT_COPY_CORE" "${QUARTUS_PROJECT_NAME}"

echo "make sure to copy/edit ${SCRIPTS_PATH}/__mister_config -> ./config/__mister_config"
