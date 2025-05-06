#!/bin/bash

export RBL="~/REBELS/RBL"
export MAYA_SHELF_PATH="$RBL/05_pipeline/tools/maya/shelves":$MAYA_SHELF_PATH

~/.ncca/scripts/goMaya.sh "$@"