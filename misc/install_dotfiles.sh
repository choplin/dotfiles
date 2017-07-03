#!/bin/bash

set -e
set -u
set -x

basedir=$(cd $(dirname $0)/..; pwd)

link(){
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        rm -rf $dest
    fi

    ln -sf $src $dest
}

for f in $basedir/_*; do
    name=$(basename $f)

    dotfile="$HOME/$(echo $name | sed -e "s/^_/./")"

    link $f $dotfile
done

link $basedir/prezto $HOME/.zprezto
link $basedir/init.vim $HOME/.config/nvim/init.vim
link $basedir/fish $HOME/.config/
