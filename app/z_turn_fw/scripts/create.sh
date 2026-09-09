#!/usr/bin/env bash

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/z_turn_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

if [ -f "${VITIS_PROJECT_FOLDER}/${VITIS_PROJECT_SLUG}.xpr" ]; then
    echo "WARNING - existing project: ${VITIS_PROJECT_FOLDER}/${VITIS_PROJECT_SLUG}.xpr"
    exit
fi

unset XSCT_CMD
command -v xsct &>/dev/null && export XSCT_CMD="xsct"
command -v xsct.bat &>/dev/null && export XSCT_CMD="xsct.bat"
[ -z $XSCT_CMD ] && echo "ERROR: can't locate xsct.bat or xsct" && exit 1

SCRIPTS_DIR="$(dirname $(realpath $0))"

mkdir ${VITIS_PROJECT_FOLDER}
cd ${VITIS_PROJECT_FOLDER} || exit

start=$(date +%s)
"$XSCT_CMD" "$SCRIPTS_DIR/create.tcl"
end=$(date +%s)
elapsed=$((end - start))

echo "============================================="
echo "create vitis project took $elapsed seconds"
echo "============================================="
