# gh review-requests with cd support (Ctrl-G Ctrl-R)
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

zle -N __fzf_gh_review_requests
bindkey "^G^R" __fzf_gh_review_requests
