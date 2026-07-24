path=(
    $HOME/.local/bin(N-/)
    $HOME/.git-scripts(N-/)
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin(N-/)
    $path
)

fpath=(
    $HOMEBREW_PREFIX/share/zsh/site-functions(N-/)
    $HOME/.zsh/functions(N-/)
    $fpath
)

export ANDROID_HOME="$HOME/Library/Android/sdk"
if [ -d "$ANDROID_HOME" ]; then
    path=(
        "$ANDROID_HOME/emulator"
        "$ANDROID_HOME/platform-tools"
        "$ANDROID_HOME/cmdline-tools/latest/bin"
        $path
    )
fi
