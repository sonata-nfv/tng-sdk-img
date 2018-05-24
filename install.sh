#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/src"
BIN_DIR=/usr/bin
OPT_DIR=/opt

cp $SOURCE_DIR/tng-sdk-img $BIN_DIR/tng-sdk-img
chmod a+x $BIN_DIR/tng-sdk-img

cp -R $SOURCE_DIR/tools $OPT_DIR/tng-sdk-img
