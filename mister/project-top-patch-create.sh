#!/usr/bin/env sh

ENV_FP="$(dirname $(realpath $0))/mister_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

SRC_PATH="$(dirname $(dirname $(realpath $0)))/src"
diff -u "${QUARTUS_PROJECT_NAME}/${QUARTUS_PROJECT_NAME}.sv-bak" "${SRC_PATH}/top.sv" > "${SRC_PATH}/top.sv.patch"
