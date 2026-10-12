#!/usr/bin/env sh

SCRIPTS_DIR="$(dirname $(realpath $0))"
. "$SCRIPTS_DIR/env"

THIS_DIR="$PWD"
OBJ_FP="${THIS_DIR}/verilator/${BUILD_DIR}"

HDL_DIR="$SCRIPTS_DIR/../../hdl/src"
cd "$HDL_DIR" || exit

if [ -f "$OBJ_FP/sim.exe" ]; then
    "$OBJ_FP/sim.exe"
    exit
elif [ -f "$OBJ_FP/sim" ]; then
    "$OBJ_FP/sim"
    exit
fi

pwrn "no $OBJ_FP/sim - build first"
