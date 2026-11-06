#!/usr/bin/env sh

FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

cd "${MB_MISTER_OUT_PATH}" || exit

smart_mv () {
  [ "$1" == "$2" ] && return
  mv "$1" "$2"
  pinf "$1 -> $2\n"
}

OFP="Template"
# rename files
# for File in *; { [[ -f $File ]] && mv "$File" "${File//${OFP}/${MB_MISTER_OPT}}"; }
for file in *; do smart_mv "$file" "$(echo "$file" | sed s/${OFP}/${MB_MISTER_OPT}/)"; done

# rename project references
sed -i "s/${OFP}/${MB_MISTER_OPT}/g" "${MB_MISTER_OPT}.qpf"
pinf "processed ${MB_MISTER_OPT}.qpf\n"
sed -i "s/${OFP}/${MB_MISTER_OPT}/g" "${MB_MISTER_OPT}.sv"
pinf "processed ${MB_MISTER_OPT}.sv\n"
sed -i "s/${OFP}/${MB_MISTER_OPT}/g" "files.qip"
pinf "processed file.qip\n"
