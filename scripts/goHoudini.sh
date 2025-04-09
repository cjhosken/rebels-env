#!/bin/bash

############################################
# Set Environment Variables
############################################

# Setup Environment Variables
HERE=$(pwd)
FILE=""

# Custom OCIO Config from Jeremy Hardin
# export OCIO=/public/bapublic/jhardin/tools/OCIO/BU_nov2024_config.ocio

# LICENSE SERVERS
export SESI_LMHOST=lepe.bournemouth.ac.uk

# Houdini Environment Variables
HFS="/opt/hfs20.5.332"
HFS_VERSION="20.5"
PYTHON_VERSION="python3.11"
HTOA=$REBELS_PLUGIN_DIR/arnold/htoa/htoa-6.3.4.1
export HOUDINI_DSO_ERROR=1

# Houdiin Setup Script
cd $HFS
source houdini_setup_bash

# Clear PYTHONPATH to avoid any issues
PYTHONPATH=""

# Default of HOUDINI_TEMP_DIR is on the root partition in /tmp so moving it to /transfer
# Check if /transfer is mounted
if ! mountpoint -q /transfer; then
    echo "/transfer is not mounted. Using fallback path for HOUDINI_TEMP_DIR."
else
    export HOUDINI_TEMP_DIR=/transfer/houdini_temp
fi

############################################
# Plugins
############################################

export HOUDINI_PATH=$HOUDINI_PATH:$HOME/houdini$HFS_VERSION:$HFS/houdini:/opt/sidefx_packages/SideFXLabs$HFS_VERSION:$HTOA

############################################
# Launching
############################################

# Change back to the original directory
cd $HERE

echo "REBELS: Starting Houdini from $HFS - this can take a few seconds..."
echo
houdini $FILE &