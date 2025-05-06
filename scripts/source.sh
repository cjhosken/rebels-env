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

# Setting up OneDrive
alias rclone="$DIR/../tools/rclone/rclone"
REBELS_ROOT="$HOME/REBELS"

if [ ! -d "$REBELS_ROOT" ]; then
    rm -rf "$REBELS_ROOT"
    mkdir -p "$REBELS_ROOT"
fi


# First, check if the mount already exists
if ! mountpoint -q "$REBELS_ROOT"; then 
    echo "Mounting REBELS..."

    # Mount with rclone (adjust your remote name and options as needed)
    rclone mount REBELS: "$REBELS_ROOT" \
        --vfs-cache-mode full \
        --allow-other \
        --daemon

    # Verify the mount was successful
    sleep 3  # Give it a moment to mount
    if mountpoint -q "$REBELS_ROOT"; then
        echo "Successfully mounted REBELS at $REBELS_ROOT"
    else
        echo "Failed to mount REBELS" >&2
        exit 1
    fi
fi

export RBL="$REBELS_ROOT/RBL"

cd $HERE