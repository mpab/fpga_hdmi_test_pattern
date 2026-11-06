#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

cp "${MB_APP_ROOT}/docs/specific/README.md" "${MB_APP_ROOT}/"
cat "${MB_APP_ROOT}/docs/generic/README.md" >> "${MB_APP_ROOT}/README.md"
