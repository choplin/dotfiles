#!/bin/bash

ls -1 |
while read i
do
    case $i in
        install_dotfiles.sh) continue ;;
        bin) continue ;;
        .git*) continue ;;
    esac

    j=`echo ${i} | sed -e "s/^_/./"`
    cmd="rm -rf ${HOME}/${j}"
    echo "execute: \"${cmd}\""
    $cmd
    cmd="ln -sf ${PWD}/$i ${HOME}/${j}"
    echo "execute: \"${cmd}\""
    $cmd
done
