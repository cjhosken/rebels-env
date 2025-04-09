#!/bin/bash

HERE=$(pwd)

export REBELS_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REBELS_SCRIPT_DIR="$REBELS_ENV_DIR/scripts"
export REBELS_PLUGIN_DIR="$REBELS_ENV_DIR/plugins"
export REBELS_SOFTWARE_DIR="$REBELS_ENV_DIR/software"

cd $REBELS_ENV_DIR

echo "REBELS: Mounting drives..."

alias rclone="$REBELS_SOFTWARE_DIR/rclone/rclone"

REBELS_DRIVE="$HOME/REBELS"
mkdir -p $REBELS_DRIVE

# Check if the drive is already mounted
if ! mountpoint -q $REBELS_DRIVE; then
    rclone --vfs-cache-mode writes mount REBELS: $REBELS_DRIVE --allow-non-empty &
    echo "REBELS: Mounting REBELS drive..."
fi
echo "REBELS: Root drive is mounted at $HOME/REBELS"

export TETE="$HOME/TETE"
mkdir -p $TETE

# Check if the drive is already mounted
if ! mountpoint -q $TETE; then
    sshfs tete@bournemouth.ac.uk:/home/$USERNAME $TETE -o reconnect,ServerAliveInterval=15
    echo "REBELS: Mounting TETE drive..."
fi
echo "REBELS: Renderfarm drive is mounted at $HOME/TETE"

export RBL="$REBELS_DRIVE/RBL"

echo "REBELS: Setting up global environemnt variables..."

export OCIO=$REBELS_PLUGIN_DIR/ocio/config.ocio

chmod +x $REBELS_SCRIPT_DIR/*.sh
alias goBlender="$REBELS_SCRIPT_DIR/goBlender.sh"
alias goChrome="$REBELS_SCRIPT_DIR/goChrome.sh"
alias goHoudini="$REBELS_SCRIPT_DIR/goHoudini.sh"
alias goMaya="$REBELS_SCRIPT_DIR/goMaya.sh"
alias goNuke="$REBELS_SCRIPT_DIR/goNuke.sh"
alias goQube="$REBELS_SCRIPT_DIR/goQube.sh"


alias goSplash="$REBELS_SCRIPT_DIR/goSplash.sh"
alias goTeteRex="$REBELS_SCRIPT_DIR/goTeteRex.sh"
alias goUSD="$REBELS_SCRIPT_DIR/goUSD.sh"

cd $HERE