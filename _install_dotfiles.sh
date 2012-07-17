#!/bin/bash

ls -1 |
while read i
do
    case $i in
        install_dotfiles.sh) continue ;;
        bin) continue ;;
    esac
    
    j=`echo ${i} | sed -e "s/^_/./"`
    cmd="ln -sf ${PWD}/$i ${HOME}/${j}"
    echo "execute: \"${cmd}\""
    $cmd
done
