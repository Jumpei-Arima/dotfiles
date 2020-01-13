#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

mkdir $SCRIPT_DIR/vim/rc/plugins
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $SCRIPT_DIR/vim/rc/plugins/installer.sh

sh $SCRIPT_DIR/vim/rc/plugins/installer.sh $SCRIPT_DIR/vim/rc/plugins
