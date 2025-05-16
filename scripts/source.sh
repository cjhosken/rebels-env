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

# Create directory if it doesn't exist
if [ ! -e "$REBELS_ROOT" ]; then
    mkdir -p "$REBELS_ROOT" || {
        echo "Error: Failed to create directory $REBELS_ROOT" >&2
    }
elif [ ! -d "$REBELS_ROOT" ]; then
    echo "Error: $REBELS_ROOT exists but is not a directory" >&2
fi

# Check if already mounted
if mountpoint -q "$REBELS_ROOT"; then
    echo "REBELS is already mounted at $REBELS_ROOT"
else
    echo "Mounting REBELS..."
    if ! rclone mount REBELS: "$REBELS_ROOT" \
        --vfs-cache-mode=writes \
        --allow-non-empty \
        --allow-other \
        --log-level DEBUG --log-file ~/rclone.log; then
        echo "Failed to mount REBELS" >&2
    fi

    # Verify mount
    sleep 1
    if mountpoint -q "$REBELS_ROOT"; then
        echo "Successfully mounted REBELS at $REBELS_ROOT"
    else
        echo "Mount appeared to succeed but verification failed" >&2
    fi
fi

export RBL="$REBELS_ROOT/RBL"

cd "$HERE"