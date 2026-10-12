#!/usr/bin/env sh

SCRIPTS_DIR="$(dirname $(realpath $0))"
. "$SCRIPTS_DIR/env"

THIS_DIR="$PWD"
OBJ_FP="$THIS_DIR/verilator/$BUILD_DIR"
mkdir -p "$OBJ_FP"

if [ "$_BUILD_TOOL" = "cmake" ]; then
  cd $SIM_CFG
  cmake -GNinja -S . -B "$OBJ_FP" -DCMAKE_BUILD_TYPE=Release
  cmake --build "$OBJ_FP"
elif [ "$_BUILD_TOOL" = "make" ]; then
  cd verilator
  make -f $SIM_CFG/Makefile
else
  perr "unknown value for _BUILD_TOOL: $_BUILD_TOOL\n"
fi

cd "$THIS_DIR"

pinf "verilator build artifacts -> $OBJ_FP\n"
