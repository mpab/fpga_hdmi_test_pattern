#!/usr/bin/env sh

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/pynq_z2_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

if [ ! -f "./vivado/vivado.xpr" ]; then
    echo "ERROR - missing project: vivado/vivado.xpr"
    exit
fi

TCL_RUNNER="$(dirname $(realpath $0))/vivado_tcl.sh"
if [ ! -f "$TCL_RUNNER" ]; then
    echo "ERROR - no script: $TCL_RUNNER"
    exit
fi

"$TCL_RUNNER" 'program-bitstream.tcl' 'batch'
