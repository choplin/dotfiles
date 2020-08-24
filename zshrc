export EDITOR=vim
export VISUAL=vim

if test -d $HOME/local/bin; then
    path=("$HOME/local/bin" $path)
fi

readonly local brew_prefix='/home/linuxbrew/.linuxbrew'
if test -d $brew_prefix; then
    path=("$brew_prefix/bin" "$brew_prefix/sbin" $path)
fi

if which go > /dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$HOME/.go
    path=("$GOROOT/bin" "$GOPATH/bin" $path)
fi

if test -d $HOME/.cargo; then
    path=("$HOME/.cargo/bin" $path)
fi

export PATH

if which direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

zstyle ':completion:*' list-colors "${LS_COLORS}"

### Added by Zinit's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of zinit installer's chunk

zinit ice pick"async.zsh" src"pure.zsh"; zinit light sindresorhus/pure

zinit ice lucid; zinit snippet PZT::modules/editor/init.zsh
zinit ice wait lucid; zinit snippet PZT::modules/history/init.zsh
zstyle ':prezto:module:utility:ls' color 'yes'
zinit ice wait lucid; zinit snippet PZT::modules/utility/init.zsh

#zinit ice wait lucid blockf atpull'zinit creinstall -q .'; zinit light zsh-users/zsh-completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for zsh-users/zsh-completions
zinit ice wait lucid atinit"zpcompinit; zpcdreplay"; zinit light zdharma/fast-syntax-highlighting
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid; zinit light zdharma/history-search-multi-word
zinit ice wait lucid; zinit light willghatch/zsh-saneopt
zinit ice wait lucid; zinit light momo-lab/zsh-abbrev-alias
zinit ice wait lucid; zinit light agkozak/zsh-z
#zinit ice pick'kube-ps1.sh'; zinit light jonmosco/kube-ps1

# Requires creinstall when updated
zinit ice wait lucid; zinit light /home/linuxbrew/.linuxbrew/share/zsh/site-functions
zinit ice wait lucid; zinit light $HOME/.zsh/completions
zinit ice lucid pick'settings.zsh'; zinit light "$HOME/.zsh"

readonly local cloudsdk_home="$HOME/local/google-cloud-sdk"
if test -d $cloudsdk_home; then
    # adding 'wait' will disable completion unexpectedly
    zinit ice lucid blockf pick'completion.zsh.inc' src'path.zsh.inc'; zinit light $cloudsdk_home
fi

readonly local sdkman_home="$HOME/.sdkman"
if test -d $sdkman_home; then
    zinit ice lucid pick'bin/sdkman-init.sh'; zinit light $sdkman_home
fi
