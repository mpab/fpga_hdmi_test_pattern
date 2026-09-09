#!/usr/bin/env sh

SCRIPTS_DIR="$(dirname $(realpath $0))"

ensure_script () {
    if [ ! -f "$1" ]; then
        echo "ERROR - no script: $1"
        exit
    fi
}

TCL_RUN="${SCRIPTS_DIR}/vivado_tcl.sh"
ensure_script "${TCL_RUN}"

TEST_ENV="${SCRIPTS_DIR}/test-env.tcl"
ensure_script "${TEST_ENV}"

"$TCL_RUN" "${TEST_ENV}" 'batch'
