#!/usr/bin/env sh

[ -z "$1" ] && echo "usage: $0 new-file-slug" && exit
OLD_FILE_PATTERN="Template"
# rename files
# for File in *; { [[ -f $File ]] && mv "$File" "${File//$OLD_FILE_PATTERN/$1}"; }
for file in *; do mv "$file" "$(echo "$file" | sed s/$OLD_FILE_PATTERN/$1/)"; done

# rename project references
sed -i "s/$OLD_FILE_PATTERN/$1/g" "$1.qpf"
sed -i "s/$OLD_FILE_PATTERN/$1/g" "$1.sv"
sed -i "s/$OLD_FILE_PATTERN/$1/g" "files.qip"
