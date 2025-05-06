#!/bin/bash

export RBL="~/REBELS/RBL"
export NUKE_PATH="$RBL/05_pipeline/tools/nuke/jhardin/bu/tools/nuke/plugins:$RBL/05_pipeline/tools/nuke/gizmos"

~/.ncca/scripts/goNuke.sh "$@"