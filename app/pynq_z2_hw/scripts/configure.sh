#!/usr/bin/env sh

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/pynq_z2_env.sh"
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

SCRIPTS_DIR="$(dirname $(realpath $0))"

ensure_script () {
    if [ ! -f "$1" ]; then
        echo "ERROR - no script: $1"
        exit
    fi
}

TCL_RUN="${SCRIPTS_DIR}/vivado_tcl.sh"
ensure_script "${TCL_RUN}"

CONFIG_PRJ="${SCRIPTS_DIR}/configure-project.tcl"
ensure_script "${CONFIG_PRJ}"

"$TCL_RUN" "${CONFIG_PRJ}" 'batch'
