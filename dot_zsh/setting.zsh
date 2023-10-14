eval "$(starship init zsh)"

path=(
    $HOME/.local/bin(N-/)
    $path
)
fpath=(
    $HOMEBREW_PREFIX/share/zsh/site-functions(N-/)
    $HOME/.zsh/functions(N-/)
    $fpath
)

if type go > /dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$HOME/.go
    path=("$GOROOT/bin" "$GOPATH/bin" $path)
fi

if test -d $HOME/.cargo; then
    source "$HOME/.cargo/env"
fi

if type direnv > /dev/null; then
    eval "$(direnv hook zsh)"
fi

local sdk_root=$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
if test -d $sdk_root; then
    zsh-defer source $sdk_root/path.zsh.inc
    zsh-defer source $sdk_root/completion.zsh.inc
fi

if test -d $HOME/.krew; then
    path=("$HOME/.krew/bin" $path)
fi
