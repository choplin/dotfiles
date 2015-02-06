#!/bin/bash

set -e
set -u
set -x

basedir=$(cd $(dirname $0)/..; pwd)

for f in $basedir/*; do
    case $f in
        misc) continue ;;
    esac

    dotfile="$HOME/$(basename $(echo $f | sed -e "s/^_/./"))"
    if [ -e "$dotfile" ]; then
        rm -rf $dotfile
    fi

    ln -sf $f $dotfile
done

if [ -e $HOME/bin ]; then
    rm -rf $HOME/bin
fi
cp -pr $basedir/bin ~/
