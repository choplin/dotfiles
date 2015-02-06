#!/bin/bash

set -e
set -u
set -x

# Homebrewを最新版にアップデート
brew update

repos=(
    homebrew/binary
    homebrew/completions
    homebrew/dupes
    homebrew/versions
    peco/peco
)

for r in ${repos[@]}; do
    brew tap $r
done

formulas=(
    caskroom/cask/brew-cask
    autoconf
    automake
    bash-completion
    bison
    boost
    boost-build
    ccache
    cgdb
    cmake
    coreutils
    cscope
    ctags
    curl
    flex
    gcc48
    gcc49
    gdb
    git
    git-now
    global
    gnu-tar
    gnu-getopt
    gnuplot
    go
    grep
    htop-osx
    hub
    lv
    sbt
    scala
    tig
    tmux
    wget
    zsh
)
brew install ${formulas[@]}

casks=(
    alfred
    anki
    bartender
    bettertouchtool
    caffeine
    dropbox
    evernote
    firefox
    google-drive
    hipchat
    intellij-idea
    iterm2
    karabiner
    kobito
    limechat
    mactex
    papers
    skype
    sourcetree
    the-unarchiver
    totalspaces
    vagrant
    virtualbox
    visualvm
    witch
    xld
)

brew cask install ${casks[@]}

# cannot work with 1password from MacAppStore
#cask install google-chrome

# license problem
#cask install onepassword
#cask install forklift

# account problem
#cask install thunderbird

# # 不要なファイルを削除
clean
