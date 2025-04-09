#!/bin/bash

unset QT_PLUGIN_PATH
unset CUDA_CACHE_MAXSIZE

NUKE_TEMP_DIR=/transfer/nuke.$USERNAME
NUKE_DISK_CACHE=/transfer/nuke-cache.$USERNAME
OFX_PLUGIN_PATH=/opt/OFX
export OFX_PLUGIN_PATH
export NUKE_DISK_CACHE
export NUKE_TEMP_DIR
export NUKE_DISK_CACHE_GB=5
export NUKE_PATH=$NUKE_PATH:$REBELS_PLUGIN_DIR/nuke/plugins

# Foundry licensing
export foundry_LICENSE=4101@beijing.bournemouth.ac.uk

# KeenTools licensing
export KEENTOOLS_LICENSE_SERVER=7096@beijing.bournemouth.ac.uk
export KEENTOOLS_LICENSE_SERVER=beijing:7096

echo "REBELS: Starting Nuke - this can take a few seconds..."
echo

/opt/Nuke14.1v4/Nuke14.1 --nukex $@ &