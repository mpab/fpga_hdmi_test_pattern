#!/usr/bin/env bash

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/z_turn_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

if [ ! -d "${VITIS_PROJECT_FOLDER}" ]; then
    echo "ERROR - missing project folder: ${VITIS_PROJECT_FOLDER}"
    exit
fi

unset XSCT_CMD
command -v xsct &>/dev/null && export XSCT_CMD="xsct"
command -v xsct.bat &>/dev/null && export XSCT_CMD="xsct.bat"
[ -z $XSCT_CMD ] && echo "ERROR: can't locate xsct.bat or xsct" && exit 1

SCRIPTS_DIR="$(dirname $(realpath $0))"
cd "${VITIS_PROJECT_FOLDER}" || exit

start=$(date +%s)
"$XSCT_CMD" "$SCRIPTS_DIR/build.tcl" "$SCRIPTS_DIR/config.tcl"
end=$(date +%s)
elapsed=$((end - start))

echo "============================================="
echo "build vitis project took $elapsed seconds"
echo "============================================="
