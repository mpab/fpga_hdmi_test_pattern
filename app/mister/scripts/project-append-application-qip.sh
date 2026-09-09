#!/usr/bin/env sh

MISTER_PROJECT_SLUG="$1"
[ -z "$MISTER_PROJECT_SLUG" ] && echo "usage: $0 PROJECT" && exit
[ ! -d "$MISTER_PROJECT_SLUG" ] && echo "missing project folder: $MISTER_PROJECT_SLUG" && exit

FILES_QIP="${MISTER_PROJECT_SLUG}/files.qip"
if [ ! -f "${FILES_QIP}" ]; then
    echo "ERROR: missing file ${FILES_QIP}"
    exit
fi

APPLICATIONS_QIP="${MISTER_PROJECT_SLUG}/application_files.qip"
if [ -f "${APPLICATIONS_QIP}" ]; then
    echo "WARNING: file ${APPLICATIONS_QIP} exists, skipping"
    exit
fi

echo "" >> "${APPLICATIONS_QIP}"
find "app/vhdl/src" -iname "*.sv" -exec echo "set_global_assignment -name SYSTEMVERILOG_FILE ../{}" \; >> "${APPLICATIONS_QIP}"

if [ ! -f "${FILES_QIP}-bak" ]; then
    cp "${FILES_QIP}" "${FILES_QIP}-bak"
    cat "${APPLICATIONS_QIP}" >> "${FILES_QIP}"
    echo "added ${APPLICATIONS_QIP} to ${FILES_QIP}"
else
    echo "${FILES_QIP}-bak exists, skipping"
fi