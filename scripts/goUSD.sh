#!/bin/bash

############################################
# Set Environment Variables
############################################

# Setup Environment Variables
HERE=$(pwd)
FILE=""

for arg in "$@"; do
    case $arg in
        *)
            FILE="$FILE $arg"
            ;;
    esac
done

# LICENSE SERVERS
export SESI_LMHOST=lepe.bournemouth.ac.uk

# Houdini Environment Variables
HFS="/opt/hfs20.5.332"
HFS_VERSION="20.5"
PYTHON_VERSION="python3.11"
HTOA=$REBELS_PLUGIN_DIR/arnold/htoa/htoa-6.3.4.1
export HOUDINI_DSO_ERROR=1

# Houdini Setup Script
cd $HFS
source houdini_setup_bash

############################################
# Plugins
############################################

export HOUDINI_PATH=$HOUDINI_PATH:$HOME/houdini$HFS_VERSION:$HFS/houdini:/opt/sidefx_packages/SideFXLabs$HFS_VERSION:$HTOA

# USD specific environment variables
export PXR_PLUGINPATH_NAME="$HFS/usd/plugins:$HFS/plugin/usd"
export LD_LIBRARY_PATH="$HFS/lib:$LD_LIBRARY_PATH"
export PATH="$HFS/bin:$PATH"

export HD_DEFAULT_RENDERER="GL"  # Force GL renderer if Storm fails

# Clear problematic USD environment variables if they exist
unset USDROOT
unset USD_INSTALL_ROOT
unset PYTHONPATH


############################################
# Launching
############################################

# Change back to the original directory
cd $HERE

echo "REBELS: Starting UsdView from $HFS - this can take a few seconds..."
echo
usdview $FILE &