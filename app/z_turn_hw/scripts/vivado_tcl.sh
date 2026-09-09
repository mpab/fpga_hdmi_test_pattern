#!/usr/bin/env sh

# echo with color
err_echo() {
	printf  "\e[1m\e[31mERROR: $1\e[0m\n"
}

wrn_echo() {
	printf  "\e[1m\e[33mWARNING: $1\e[0m\n"
}

inf_echo() {
	printf  "\e[1m\e[30mINFO: $1\e[0m\n"
}

ok_echo() {
	printf  "\e[1m\e[32m$1\e[0m\n"
}

cleanup_dir () {
    rm -f *.jou
    rm -f *.log
    rm -rf .Xil
    rm -rf NA
}

XIL_ENV_ERR=
[ -z "$(command -v vivado)" ] && err_echo "vivado not found" && XIL_ENV_ERR=1
[ ! -z "$XIL_ENV_ERR" ] && exit

VIVADO_VERSION=$(vivado -version | grep "vivado v" | sed "s/^.*vivado v//" | sed "s/ (64-bit)//" | sed "s/\r//" | sed "s/\n//")
SCRIPT_FP="$1"
[ ! -f "$SCRIPT_FP" ] && err_echo "invalid script $SCRIPT_FP: usage $0 script.tcl <batch|gui> " && exit
[ -z "$2" ] && err_echo "specify mode: usage $0 script.tcl <batch|gui> " && exit

mkdir -p logs

inf_echo "vivado version $VIVADO_VERSION"
inf_echo "vivado -mode $2 -source $SCRIPT_FP"

ENV_FP="$(dirname $(dirname $(dirname $(realpath $0))))/z_turn_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

start=$(date +%s)
vivado -mode "$2" -source "$SCRIPT_FP" -log ./logs/${1##*/}.log | grep -E 'ERROR:|WARNING:|INFO:'
end=$(date +%s)
elapsed=$((end-start))

cleanup_dir

inf_echo "========================================================================================"
inf_echo "$SCRIPT_FP took $elapsed seconds"
inf_echo "----------------------------------------------------------------------------------------"
