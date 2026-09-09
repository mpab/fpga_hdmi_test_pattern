#!/usr/bin/env sh

SCRIPTS_DIR="$(dirname $(realpath $0))"
. "$SCRIPTS_DIR/env"

THIS_DIR="$PWD"
OBJ_FP="$THIS_DIR/verilator/$BUILD_DIR"

pwrn "deleting $OBJ_FP\n"
rm -rf "$OBJ_FP"
