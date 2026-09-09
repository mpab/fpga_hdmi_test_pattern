#!/usr/bin/env sh

SCRIPTS_DIR="$(dirname $(realpath $0))"
. "$SCRIPTS_DIR/env"

THIS_DIR="$PWD"
OBJ_FP="$THIS_DIR/verilator/$BUILD_DIR"

. "$SCRIPTS_DIR/build.sh"
cd "$SCRIPTS_DIR/../../vhdl/src"

if [ -f "$OBJ_FP/sim.exe" ]; then
    "$OBJ_FP/sim.exe"
elif [ -f "$OBJ_FP/sim" ]; then
    "$OBJ_FP/sim"
fi

cd "$THIS_DIR"
