if type zoxide >/dev/null; then
    eval "$(zoxide init zsh)"

fi

function __fzf_zoxide() {
    local res
    if [ -n "$LBUFFER" ]; then
        res=$(zoxide query -i -- ${LBUFFER})
    else
        res=$(zoxide query -i)
    fi

    if [ -n "$res" ]; then
        BUFFER="cd \"$res\""
        zle accept-line
    fi
    zle reset-prompt
}

zle -N __fzf_zoxide
bindkey '^g^g' __fzf_zoxide
