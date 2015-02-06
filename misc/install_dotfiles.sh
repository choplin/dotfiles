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

for f in $basedir/*; do
    name=$(basename $f)

    case $name in
        misc) continue ;;
    esac

    dotfile="$HOME/$(echo $name | sed -e "s/^_/./")"

    link $f $dotfile
done

link $basedir/misc/bin $HOME/bin
link $basedir/misc/oh-my-zsh-custom $HOME/.oh-my-zsh/custom
