#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

mkdir $SCRIPT_DIR/vim/rc/plugins
mkdir $SCRIPT_DIR/vim/undo
curl https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh > $SCRIPT_DIR/vim/rc/plugins/installer.sh

sh $SCRIPT_DIR/vim/rc/plugins/installer.sh $SCRIPT_DIR/vim/rc/plugins