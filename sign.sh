#!/bin/bash
#
# Script to invoke AIS to sign specific file.
#
# Parameters:
#  1: Input File
#  2: Output Folder
#
# On success it will remove the original file.
#
# The script uses the content of environment settings:
#  ITEXT: base folder for the AIS iText component
#  CFG: config file for the AIS iText component
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
    echo "$DATE ais-foldersigner:sign::$2"
    if [ "$3" != "" ]; then echo "$3" ; fi
  fi
}

# Get the Path of the script
PWD=$(dirname $0)

# Sign the passed document
IN=$1
[ -r "$IN" ] || error "File to be signed ($IN) missing or not readable"
TO=$2"/"$(basename "$IN")
inform "Signing document $IN as $TO"

if [ -r "$TO" ]; then
  inform "  Target file $TO already exists, removing it"
  rm "$TO"
  [ -r "$TO.result.txt" ] && rm "$TO.result.txt"
fi

[ "$SIGNATURE_TYPE" = "" ] && SIGNATURE_TYPE="sign"
java -cp "$ITEXT/jar/signpdf-1.0.5.jar:$ITEXT/lib/*" com.swisscom.ais.itext.SignPDF -config=$CFG -type=$SIGNATURE_TYPE -infile="$IN" -outfile="$TO" -v > "$TO.result.txt"
RC_JAVA=$?

if [ "$RC_JAVA" = "0" ]; then				# Parse the signing result
   inform "  Signing $IN: success"
   rm "$IN"
 else                                   # -> error
   RC_INFO=`cat "$TO.result.txt"`
   error "  Signing $IN: error ($RC_JAVA)" "$RC_INFO"
fi
