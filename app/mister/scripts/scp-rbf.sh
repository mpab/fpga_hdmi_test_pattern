#!/usr/bin/env sh

MISTER_CONFIG="./config/__mister_config"
[ ! -f "${MISTER_CONFIG}" ] && echo "missing file: ${MISTER_CONFIG}" && exit
. "${MISTER_CONFIG}"

ENV_FP="$(dirname $(realpath $0))/mister_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

OUTPUT_DIR="${QUARTUS_PROJECT_NAME}/output_files"
[ ! -d "./$OUTPUT_DIR/" ] && echo "missing folder: $OUTPUT_DIR" && exit

CMD="ssh root@$MISTER_HOST mkdir -p /media/fat/$MISTER_PROJECT_DIR"
echo "$CMD"
eval "$CMD"
CMD="scp ./${OUTPUT_DIR}/${QUARTUS_PROJECT_NAME}.rbf root@${MISTER_HOST}:/media/fat/${MISTER_PROJECT_DIR}/${MISTER_PROJECT_SLUG}.rbf"
echo "$CMD"
eval "$CMD"
