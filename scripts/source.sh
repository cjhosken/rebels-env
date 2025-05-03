#!/bin/bash

HERE=$(pwd)

export DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OCIO_FILE=$(ls -d "$DIR"/../ocio/*.ocio 2>/dev/null | head -n 1)
if [ -n "$OCIO_FILE" ]; then
    export OCIO="$OCIO_FILE"
fi

alias rblHoudini="$DIR/rblHoudini.sh"
alias rblComfy="$DIR/rblComfy.sh"
alias rblMaya="$DIR/rblMaya.sh"
alias rblNuke="$DIR/rblNuke.sh"
alias rblSplash="$DIR/rblSplash.sh"
alias rblHouTete="$DIR/rblHouTete.sh"

cd $HERE