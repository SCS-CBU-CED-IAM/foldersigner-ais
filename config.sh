#!/bin/bash
#
# Script to configure the environment.
#
# License: Licensed under the Apache License, Version 2.0 or later; see LICENSE.md

# Ensure work folder is present
mkdir -p $WORK

# signpdf.properties
if [ ! -e $CFG ]; then
 # Use the sample config file provided by the repository
  cp $ITEXT/signpdf.properties $CFG
 # Replace the settings with the environment one.
  sed -i -e "s,CUSTOMER=.*,CUSTOMER=$CUSTOMER_ID," $CFG
  sed -i -e "s,KEY_STATIC=.*,KEY_STATIC=$CUSTOMER_KEY," $CFG
 # Define other settings
  sed -i -e "s,CERT_FILE=.*,CERT_FILE=$WORK/mycert.crt," $CFG
  sed -i -e "s,CERT_KEY=.*,CERT_KEY=$WORK/mycert.key," $CFG
  sed -i -e "s,SSL_CA=.*,SSL_CA=$ITEXT/ais-ca-ssl.crt," $CFG
  sed -i -e "s,DIGEST_METHOD=.*,DIGEST_METHOD=$DIGEST_METHOD," $CFG
fi

# Ensure work folders are present
mkdir -p $FOLDER_IN
mkdir -p $FOLDER_OUT
