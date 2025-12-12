# Ctrl-P and Ctrl-N for up and down history search
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# Option+←/→ for moving by words
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

