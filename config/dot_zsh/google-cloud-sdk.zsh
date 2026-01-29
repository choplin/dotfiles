local sdk_root=$HOMEBREW_PREFIX/Caskroom/gcloud-cli/latest/google-cloud-sdk
if test -d $sdk_root; then
    zsh-defer source $sdk_root/path.zsh.inc
    zsh-defer source $sdk_root/completion.zsh.inc
fi
