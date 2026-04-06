__gh_review_requests_cmd="${commands[gh-review-requests]}"

function __fzf_gh_review_requests() {
    zle -I
    local path
    path=$("$__gh_review_requests_cmd" --cd)
    if [[ -n "$path" ]]; then
        BUFFER="cd \"${path}\""
        zle accept-line
    fi
    zle reset-prompt
}

wk-register "Ctrl-G Ctrl-V" "GitHub: Review Requests" __fzf_gh_review_requests
