#!/bin/bash

export RBL="~/REBELS/RBL"
export HOUDINI_OTLSCAN_PATH="$RBL/05_pipeline/tools/houdini/otls":$HOUDINI_OTLSCAN_PATH
export HOUDINI_TOOLBAR_PATH="$RBL/05_pipeline/tools/houdini/shelves":$HOUDINI_TOOLBAR_PATH

~/.ncca/scripts/goHoudini.sh --arnold "$@"
#~/.ncca/scripts/goHoudini.sh --arnold --prman "$@"