#!/bin/bash

export RBL="~/REBELS/RBL"
export NUKE_PATH="$RBL/05_pipeline/tools/nuke/gizmos":$NUKE_PATH

~/.ncca/scripts/goNuke.sh "$@"