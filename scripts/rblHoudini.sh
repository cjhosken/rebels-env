#!/bin/bash
export RBL="$HOME/REBELS/RBL"
export HFS="/opt/hfs20.5.332"
export HOUDINI_USER_PREF_DIR="$RBL/05_pipeline/tools/houdini20.5"
export HOUDINI_PATH=$HOUDINI_USER_PREF_DIR:$HOUDINI_PATH

~/.ncca/scripts/goHoudini.sh --arnold "$@"
#~/.ncca/scripts/goHoudini.sh --arnold --prman "$@"