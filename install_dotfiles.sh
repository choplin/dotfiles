#!/bin/bash

find . |
sed -e "s/^.\///" |
while read i
do
    case $i in
        *~) continue ;;
        install_dotfiles.sh) continue ;;
        .git*) continue ;;
    esac
    
    j=`echo ${i} | sed -e "s/^_/./"`
    if [ -d $i ]
    then
        if [ ! -d "${HOME}/${j}" ]
        then
            mkdir -p "${HOME}/${j}"
        fi
    else
        ln -sf ${PWD}/$i ${HOME}/${j}
    fi
done