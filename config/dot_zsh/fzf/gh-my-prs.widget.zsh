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

wk-register "Ctrl-G Ctrl-P" "GitHub: My PRs" __fzf_gh_my_prs
