#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")" || exit 1

DEFAULT_PROFILE="personal"
BACKUP_PATH=../../profiles/"${1:-$DEFAULT_PROFILE}"/packages

mkdir -p "${BACKUP_PATH}"

apt-mark showmanual | sort | grep -v -F -f <(apt show "$(apt-mark showmanual)" 2> /dev/null | grep -e ^Depends -e ^Pre-Depends | sed 's/^Depends: //; s/^Pre-Depends: //; s/(.*)//g; s/:any//g' | tr -d ',|' | tr ' ' '\n' | grep -v ^$ | sort -u) > "${BACKUP_PATH}"/apt.txt

snap list | awk '{if (NR > 1) print $1}' > "${BACKUP_PATH}"/snap.txt

npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > "${BACKUP_PATH}"/npm.txt

pip freeze > "${BACKUP_PATH}"/python.txt
