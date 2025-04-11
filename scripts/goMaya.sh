#!/bin/bash

############################################
# Set Environment Variables
############################################

# Setup Environment Variables
HERE=$(pwd)
FILE=""

# Custom OCIO Config from Jeremy Hardin
#export OCIO=/public/bapublic/jhardin/tools/OCIO/BU_nov2024_config.ocio

# Maya Environment Variables
MAYA_VERSION=2023
export AW_LOCATION=/usr/autodesk
export MAYA_LOCATION=$AW_LOCATION/maya$MAYA_VERSION

############################################
# Plugins
############################################

# ----- Renderman ----- #
export PIXAR_LICENSE_FILE=9010@talavera.bournemouth.ac.uk

export RMANTREE=/opt/pixar/RenderManProServer-26.2
export RFMTREE=/opt/pixar/RenderManForMaya-26.2

export MAYA_PLUG_IN_PATH=$RFMTREE/plug-ins:$MAYA_PLUG_IN_PATH
export MAYA_SCRIPT_PATH=$RFMTREE/scripts:$MAYA_SCRIPT_PATH
export MAYA_MODULE_PATH=$MAYA_MODULE_PATH:$RFMTREE/etc

export XBMLANGPATH="$RFMTREE/icons/":$XBMLANGPATH

export PYTHONPATH=$RFMTREE/scripts:$RFMTREE/scripts/rfm2:$PYTHONPATH

# ----- Maya Developer Kit ----- #
export MAYA_PLUG_IN_PATH=/usr/autodesk/maya/devkit-files/plug-ins:$MAYA_PLUG_IN_PATH
export MAYA_SCRIPT_PATH=/usr/autodesk/maya/devkit-files/scripts:$MAYA_SCRIPT_PATH
export XBMLANGPATH=/usr/autodesk/maya/devkit-files/icons/%B:$XBMLANGPATH


# ----- VRAY ----- #
VRAY=/usr/ChaosGroup/V-Ray/Maya2023-x64/vray
export LD_LIBRARY_PATH=$VRAY/lib:$LD_LIBRARY_PATH
export VRAY_AUTH_CLIENT_FILE_PATH=/opt

# ----- Houdini Engine ----- #
HOUDINI_VERSION="/opt/hfs20.5.332"
export MAYA_PLUG_IN_PATH=$MAYA_PLUG_IN_PATH:$HOUDINI_VERSION/engine/maya$MAYA_VERSION/plug-ins
export MAYA_SCRIPT_PATH=$MAYA_SCRIPT_PATH:$HOUDINI_VERSION/engine/maya$MAYA_VERSION/scripts
export MAYA_MODULE_PATH=$MAYA_MODULE_PATH:$HOUDINI_VERSION/engine/maya
export MAYA_MMSET_DEFAULT_XCURSOR=1

# ----- Yeti ----- #

YETI=/opt/yeti/Yeti-v4.2.12_Maya2023-linux

export XBMLANGPATH=$YETI/icons/%B:$XBMLANGPATH
export MAYA_PLUG_IN_PATH=$MAYA_PLUG_IN_PATH:$YETI/plug-ins
export MAYA_MODULE_PATH=$MAYA_MODULE_PATH:$YETI
export MAYA_SCRIPT_PATH=$MAYA_SCRIPT_PATH:$YETI/scripts

export LD_LIBRARY_PATH=$YETI/plug-ins:$LD_LIBRARY_PATH

export TMPDIR=/tmp
export RLM_LICENSE=5063@burton

############################################
# Launching
############################################

echo "REBELS: Starting Maya - this can take a few seconds..."
echo
$MAYA_LOCATION/bin/maya $1
echo "Maya has quit."