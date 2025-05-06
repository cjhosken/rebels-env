#!/bin/bash
export RBL="~/REBELS/RBL"
export HFS="/opt/hfs20.5.332"
export SIDEFX_LABS="/opt/sidefx_packages/SideFXLabs20.5"
export HOUDINI_OTLSCAN_PATH="$RBL/05_pipeline/tools/houdini/otls:$HFS/houdini/otls:$HFS/packages/apex/otls:$HFS/packages/kinefx/otls:$HFS/packages/sculpt/otls:$SIDEFX_LABS/otls:$HOUDINI_OTLSCAN_PATH"
export HOUDINI_TOOLBAR_PATH="$RBL/05_pipeline/tools/houdini/shelves:$HFS/houdini/toolbar:$HFS/packages/apex/toolbar:$HFS/packages/kinefx/toolbar:$HFS/packages/sculpt/toolbar:$SIDEFX_LABS/toolbar:$HOUDINI_TOOLBAR_PATH"

~/.ncca/scripts/goHoudini.sh --arnold "$@"
#~/.ncca/scripts/goHoudini.sh --arnold --prman "$@"