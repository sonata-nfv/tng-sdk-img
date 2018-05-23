#!/bin/bash

SOURCE_DIR=./src
BIN_DIR=/usr/bin
OPT_DIR=/opt

cp $SOURCE_DIR/tng-sdk-img.sh $BIN_DIR/tng-sdk-img
chmod 755 $BIN_DIR/tng-sdk-img

cp -R $SOURCE_DIR/tools $OPT_DIR/tng-sdk-img
