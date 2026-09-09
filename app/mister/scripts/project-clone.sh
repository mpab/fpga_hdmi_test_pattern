#!/usr/bin/env sh

[ -z "$1" ] && echo "usage: $0 new-file-slug" && exit

DEFAULT_SLUG="Template_MiSTer"
MISTER_PROJECT_SLUG="$1"

[ -d "$MISTER_PROJECT_SLUG" ] && echo "folder: $MISTER_PROJECT_SLUG exists" && exit

if [ ! -d "$DEFAULT_SLUG" ]; then
    git clone "https://github.com/MiSTer-devel/$DEFAULT_SLUG"
else
    THIS_DIR="$PWD"
    cd "$DEFAULT_SLUG" || exit
    git pull
    cd "$THIS_DIR"
fi

cp -R "$DEFAULT_SLUG" "$MISTER_PROJECT_SLUG"
cd "$MISTER_PROJECT_SLUG"
rm -rf .git
