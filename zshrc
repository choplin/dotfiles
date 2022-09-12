# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
case ${OSTYPE} in
  darwin*)
    if test -d /opt/homebrew; then
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
    ;;
  linux*)
    if test -d /home/linuxbrew/.linuxbrew; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    ;;
esac

bindkey -d

eval "$(sheldon source)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
