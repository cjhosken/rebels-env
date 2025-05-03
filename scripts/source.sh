#!/bin/bash

HERE=$(pwd)

export DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

alias rclone="$DIR/../tools/rclone/rclone"

OCIO_FILE=$(ls -d "$DIR"/../ocio/*.ocio 2>/dev/null | head -n 1)
if [ -n "$OCIO_FILE" ]; then
    export OCIO="$OCIO_FILE"
fi

# DRIVE MOUNTING (BROKEN)

#REBELS_DRIVE="$HOME/REBELS"
#mkdir -p $REBELS_DRIVE
#chmod 700 "$REBELS_DRIVE"

# Check if the drive is already mounted
#if ! mountpoint -q "$REBELS_DRIVE"; then
#    if ! rclone mount REBELS: "$REBELS_DRIVE" \
#        --vfs-cache-mode writes \
#        --allow-non-empty; then
#        echo "ERROR: Failed to mount REBELS drive" >&2
#    else
#    echo "REBELS: Root drive is mounted at $REBELS_DRIVE"
#    fi
#fi
#
#export RBL="$REBELS_DRIVE/RBL"

alias rblHoudini="$DIR/rblHoudini.sh"
alias rblComfy="$DIR/rblComfy.sh"
alias rblMaya="$DIR/rblMaya.sh"
alias rblNuke="$DIR/rblNuke.sh"

alias rblSplash="$DIR/rblSplash.sh"
alias rblHouTete="$DIR/rblHouTete.sh"

cd $HERE