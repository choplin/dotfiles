__gh_my_issues_cmd="${commands[gh-my-issues]}"

function __fzf_gh_my_issues() {
    zle -I
    local path
    path=$("$__gh_my_issues_cmd" --cd)
    if [[ -n "$path" ]]; then
        BUFFER="cd \"${path}\""
        zle accept-line
    fi
    zle reset-prompt
}

wk-register "Ctrl-G Ctrl-I" "GitHub: My Issues" __fzf_gh_my_issues
