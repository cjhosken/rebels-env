#!/bin/bash

HERE=$(pwd)

export REBELS_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REBELS_SCRIPT_DIR="$REBELS_ENV_DIR/scripts"
export REBELS_PLUGIN_DIR="$REBELS_ENV_DIR/plugins"
export REBELS_SOFTWARE_DIR="$REBELS_ENV_DIR/software"

cd $REBELS_ENV_DIR

alias rclone="$REBELS_SOFTWARE_DIR/rclone/rclone"

REBELS_DRIVE="$HOME/REBELS"
mkdir -p $REBELS_DRIVE

# Check if the drive is already mounted
if ! mountpoint -q $REBELS_DRIVE; then
    rclone --vfs-cache-mode writes mount REBELS: $REBELS_DRIVE --allow-non-empty &
    echo "REBELS: Root drive is mounted at $HOME/REBELS"
fi

export TETE="$HOME/TETE"
mkdir -p $TETE

# Check if the drive is already mounted
if ! mountpoint -q $TETE; then
    rclone --vfs-cache-mode writes mount TETE: $TETE \
        --sftp-user=$(whoami) \
        --sftp-pass="" \
        --allow-non-empty --vfs-cache-mode full &
    echo "REBELS: Renderfarm Root is mounted at $HOME/TETE"
    
fi

#echo "REBELS: Renderfarm drive is mounted at $HOME/TETE"

export RBL="$REBELS_DRIVE/RBL"

export OCIO=$REBELS_PLUGIN_DIR/ocio/config.ocio

chmod +x $REBELS_SCRIPT_DIR/*.sh
alias rblBlender="$REBELS_SCRIPT_DIR/goBlender.sh"
alias rblChrome="$REBELS_SCRIPT_DIR/goChrome.sh"
alias rblHoudini="$REBELS_SCRIPT_DIR/goHoudini.sh"
alias rblMaya="$REBELS_SCRIPT_DIR/goMaya.sh"
alias rblNuke="$REBELS_SCRIPT_DIR/goNuke.sh"
alias rblQube="$REBELS_SCRIPT_DIR/goQube.sh"


alias rblSplash="$REBELS_SCRIPT_DIR/goSplash.sh"
alias rblHouTete="$REBELS_SCRIPT_DIR/goHouTete.sh"
alias rblUSD="$REBELS_SCRIPT_DIR/goUSD.sh"

cd $HERE