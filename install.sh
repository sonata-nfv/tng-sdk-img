#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share"

[[ -d $BIN_DIR ]] || mkdir -p $BIN_DIR
[[ -d $APP_DIR ]] || mkdir -p $APP_DIR

cp $SOURCE_DIR/tng-sdk-img $BIN_DIR/tng-sdk-img
chmod a+x $BIN_DIR/tng-sdk-img

rm -rf $APP_DIR/tng-sdk-img
cp -R $SOURCE_DIR/tools $APP_DIR/tng-sdk-img
