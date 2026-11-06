#!/usr/bin/env bash
SCRIPT_PATH="$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))/"
cd "${SCRIPT_PATH}" || exit

. "./env.sh"

# print in declaration order
while IFS= read -r LINE || [[ -n "$LINE" ]]; do
  EV="${LINE%%=*}"
  MB_="${EV:0:3}"
  if [[ "${MB_}" == "MB_" ]]; then
    echo ${EV} ${!EV}
  fi
done < "./env.sh"
