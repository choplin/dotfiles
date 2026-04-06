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

wk-register "Ctrl-G Ctrl-G" "Zoxide: Directory Jump" __fzf_zoxide

