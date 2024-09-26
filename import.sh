#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname $0))

clear_all_dir_in() {
    for item in $(ls -d $(realpath $1)/*/); do
        rm -rf $item
    done
}

clear_all_dir_in $SCRIPT_DIR/oh-my-scripts/scripts/custom/
clear_all_dir_in $SCRIPT_DIR/oh-my-scripts/scripts/dev/

cp -r $SCRIPT_DIR/src/custom/* $SCRIPT_DIR/oh-my-scripts/scripts/custom/
cp -r $SCRIPT_DIR/src/dev/* $SCRIPT_DIR/oh-my-scripts/scripts/dev/
