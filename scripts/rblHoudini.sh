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

goHoudini --arnold --prman