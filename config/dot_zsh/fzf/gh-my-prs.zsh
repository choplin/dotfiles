# gh my-prs with cd support (Ctrl-G Ctrl-P)
__gh_my_prs_cmd="${commands[gh-my-prs]}"

function __fzf_gh_my_prs() {
    zle -I
    local path
    path=$("$__gh_my_prs_cmd" --cd)
    if [[ -n "$path" ]]; then
        BUFFER="cd \"${path}\""
        zle accept-line
    fi
    zle reset-prompt
}

zle -N __fzf_gh_my_prs
bindkey "^G^P" __fzf_gh_my_prs
