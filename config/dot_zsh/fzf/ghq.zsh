# ghq integration
# Function to select a repository using fzf
function __fzf_ghq() {
    local root=$(ghq root)
    local result=$(
        (
            echo "Enter: cd, Ctrl-O: Insert path" &&
            ghq list
        ) | fzf --header-lines 1 \
            --select-1 --exit-0 \
            --preview="ls ${root}/{}" \
            --bind 'enter:accept' \
            --bind 'ctrl-o:print(__insert)+accept')

    if [[ $result == __insert* ]]; then
        local LF=$'\n'
        local selected_dir=${result#*$LF}
        LBUFFER+="${root}/${selected_dir}"
    elif [ -n "$result" ]; then
        BUFFER="cd ${root}/${result}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N __fzf_ghq
bindkey "^]" __fzf_ghq
