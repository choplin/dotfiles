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

mkdir -p $HOME/.config/nvim
link $basedir/init.vim $HOME/.config/nvim/init.vim

mkdir -p $HOME/.config/fish
for f in $basedir/fish/*.fish; do
    name=$(basename $f)
    link $f $HOME/.config/fish/$name
done

mkdir -p $HOME/.config/fish/functions
for f in $basedir/fish/functions/*.fish; do
    name=$(basename $f)
    link $f $HOME/.config/fish/functions/$name
done
