#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

[ -f "${MB_MISTER_PROJ_QPF_FP}" ] && pwrn "existing project: ${MB_MISTER_PROJ_QPF_FP}\n" && exit

check_filepath () {
    if [ ! -f "$1" ]; then
        echo "ERROR - no file: $1"
        exit
    fi
}

PROJECT_CLONE="${MB_MISTER_PROJ_PATH}project-clone-template.sh"
check_filepath "${PROJECT_CLONE}"

PROJECT_RENAME_REFERENCES="${MB_MISTER_PROJ_PATH}project-rename-references.sh"
check_filepath "${PROJECT_RENAME_REFERENCES}"

PROJECT_APPEND_APPLICATION_QIP="${MB_MISTER_PROJ_PATH}project-append-application-qip.sh"
check_filepath "${PROJECT_APPEND_APPLICATION_QIP}"

PROJECT_COPY_CORE="${MB_MISTER_PROJ_PATH}project-replace-core.sh"
check_filepath "${PROJECT_COPY_CORE}"

"$PROJECT_CLONE"

[ -d "${MB_MISTER_OUT_PATH}" ] && pwrn "folder: ${MB_MISTER_OUT_PATH} exists\n" && exit

cp -R "${MB_MISTER_OUT_PROJ_TEMPLATE_PATH}" "${MB_MISTER_OUT_PATH}"
cd "${MB_MISTER_OUT_PATH}"
rm -rf .git
"$PROJECT_RENAME_REFERENCES"
"$PROJECT_APPEND_APPLICATION_QIP"
"$PROJECT_COPY_CORE"
