#!/bin/bash

HERE=$(pwd)
FILE=""

for arg in "$@"; do
    case $arg in
        *)
            FILE="$FILE $arg"
            ;;
    esac
done

# Set OCIO configuration path
OCIO_FILE=$(ls -d "$DIR"/../ocio/*.ocio 2>/dev/null | head -n 1)
if [ -n "$OCIO_FILE" ]; then
    export OCIO="$OCIO_FILE"
fi

goNuke --ocio $OCIO_FILE $FILE