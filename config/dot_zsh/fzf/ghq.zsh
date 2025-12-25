# ghq integration
# Function to select a repository using fzf
function __fzf_ghq() {
    local fzf_options=('--select-1' '--exit-0')
    local root=$(ghq root)
    local selected_dir=$(ghq list | fzf --query="$LBUFFER" $fzf_options --preview="ls ${root}/{}")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${root}/${selected_dir}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N __fzf_ghq
bindkey "^]" __fzf_ghq
