#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

cd "${MB_MISTER_OUT_PATH}" || exit

FILES_QIP="files.qip"
if [ ! -f "${FILES_QIP}" ]; then
    perr "missing: ${FILES_QIP}\n"
    exit
fi

APPLICATIONS_QIP="application_files.qip"
if [ -f "${APPLICATIONS_QIP}" ]; then
    pwrn "file ${APPLICATIONS_QIP} exists, skipping\n"
    exit
fi

echo "" >> "${APPLICATIONS_QIP}"
find "../../hdl/" -iname "*.sv" -exec echo "set_global_assignment -name SYSTEMVERILOG_FILE {}" \; >> "${APPLICATIONS_QIP}"
pinf "added ../../*.sv to ${APPLICATIONS_QIP}\n"

if [ ! -f "${FILES_QIP}-bak" ]; then
    cp "${FILES_QIP}" "${FILES_QIP}-bak"
    cat "${APPLICATIONS_QIP}" >> "${FILES_QIP}"
    pinf "added ${APPLICATIONS_QIP} to ${FILES_QIP}\n"
else
    pwrn "${FILES_QIP}-bak exists, skipping\n"
fi