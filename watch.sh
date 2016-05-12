#!/bin/bash
#
# Script to watch a folder for new PDF files and invoke sign.sh
#
# The script uses the content of environment settings:
#  FOLDER_IN: the folder to watch for new PDF files
#  FOLDER_OUT: the folder where to place the digitally signed PDF files
#
# License: Licensed under the Apache License, Version 2.0 or later; see LICENSE.md

# Logging functions
[ "$VERBOSITY" = "" ] && VERBOSITY=2
silent_lvl=0
inf_lvl=1
err_lvl=2
dbg_lvl=3

inform() { log $inf_lvl "INFO: $@"; }
error() { log $err_lvl "ERROR: $@"; }
debug() { log $dbg_lvl "DEBUG: $@"; }
log() {
  DATE=$(date "+%Y-%m-%d %H:%M:%S")
  if [ $VERBOSITY -ge $1 ]; then         # Logging to syslog and STDERR
    echo "$DATE ais-foldersigner:watch::$2"
    if [ "$3" != "" ]; then echo "$3" ; fi
  fi
}

# Get the Path of the script
PWD=$(dirname $0)

# IN and OUT defaults
[ "$FOLDER_IN" = "" ] && FOLDER_IN="$PWD/in"
[ "$FOLDER_OUT" = "" ] && FOLDER_OUT="$PWD/out"
while true
do
  inform "Watching for new *.pdf files in $FOLDER_IN (older than 1 min)"
  find $FOLDER_IN -iname *.pdf -mmin +1 -exec $PWD/sign.sh {} $FOLDER_OUT \;
  sleep 60
done
