if test -d $HOMEBREW_PREFIX/opt/fzf; then
    source $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "^]" ghq-fzf
