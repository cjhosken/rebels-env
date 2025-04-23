#!/bin/bash

HERE=$(pwd)

export DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

alias rclone="$REBELS_SOFTWARE_DIR/rclone/rclone"

REBELS_DRIVE="$HOME/REBELS"
mkdir -p $REBELS_DRIVE
chmod 700 "$REBELS_DRIVE"

fusermount -uz $REBELS_DRIVE

# Check if the drive is already mounted
if ! mountpoint -q $REBELS_DRIVE; then
    rclone mount REBELS: $REBELS_DRIVE \
    --vfs-cache-mode writes \
    --allow-other \
    --allow-non-empty \
    --no-modtime \
    --daemon

    echo "REBELS: Root drive is mounted at $HOME/REBELS"
fi

export RBL="$REBELS_DRIVE/RBL"

alias rblHoudini="$DIR/rblHoudini.sh"
alias rblComfy="$DIR/rblComfy.sh"
alias rblMaya="$DIR/rblMaya.sh"
alias rblNuke="$DIR/rblNuke.sh"

alias rblSplash="$DIR/rblSplash.sh"
alias rblHouTete="$DIR/rblHouTete.sh"

cd $HERE