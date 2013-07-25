#!/bin/bash

set -e
set -u

basedir=$(dirname $0)

ls -1 ${basedir} |
while read i
do
    case ${i} in
        install_dotfiles.sh) continue ;;
        bin) continue ;;
        .git*) continue ;;
    esac

    j=`echo ${i} | sed -e "s/^_/./"`
    cmd="rm -rf ${HOME}/${j}"
    echo "execute: \"${cmd}\""
    $cmd
    cmd="ln -sf ${basedir}/${i} ${HOME}/${j}"
    echo "execute: \"${cmd}\""
    ${cmd}
done

cp -pr ${basedir}/bin ~/
