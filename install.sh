#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share"

[[ -d ]] || mkdir $BIN_DIR
[[ -d ]] || mkdir $APP_DIR

cp $SOURCE_DIR/tng-sdk-img $BIN_DIR/tng-sdk-img
chmod a+x $BIN_DIR/tng-sdk-img

cp -R $SOURCE_DIR/tools $APP_DIR/tng-sdk-img
