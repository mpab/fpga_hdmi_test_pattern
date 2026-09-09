#!/usr/bin/env sh

MISTER_CONFIG="./config/__mister_config"
[ ! -f "${MISTER_CONFIG}" ] && echo "missing file: ${MISTER_CONFIG}" && exit
. "${MISTER_CONFIG}"

ssh "root@$MISTER_HOST"
