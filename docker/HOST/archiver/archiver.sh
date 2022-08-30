#!/bin/bash

# Print expected input if no valid input is given
if [ $# != 3 ]; then
  echo "usage: $0 <cache-drive> <backing-pool> <days-old>"
  exit 1
fi

# Variables
CACHE="${1}"
BACKING="${2}"
N=${3}
# Not required but handy, get path to this script
SCRIPTDIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

# Find access time of files in cache pool, move with rsync if >N, log to a file next to script.
find "${CACHE}" -type f -atime +${N} -printf '%P\n' | nocache rsync -axHAXWES --progress --files-from=- --exclude-from="${SCRIPTDIR}"/archiver_exclude.txt --preallocate --remove-source-files "${CACHE}/" "${BACKING}/" >> $HOME/docker/HOST/logs/archiver.log 2>&1

