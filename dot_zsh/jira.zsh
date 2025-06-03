__JIRA_ONGOING_STATUSES=(-s"To Do" -s"In Progress" -s"In Review")
__JIRA_ISSUE_LIST_OPTS=(--history --plain ${__JIRA_ONGOING_STATUSES[@]})
__JIRA_FZF_OPTS=(
    --border
    --border-label "JIRA Issues"
    --height=40% --layout=reverse --info=inline
)

__jira_host() {
    cat "$HOME/.config/.jira/.config.yml" | yq .server
}

__jira_open_browser_bind_cmd=$(cat <<EOF
    local url="$(__jira_host)/browse/{r2}"
    if command -v xdg-open &> /dev/null; then
        xdg-open "\$url"
    elif command -v open &> /dev/null; then
        open "\$url"
    else
        echo "No suitable browser command found to open the URL."
        return 1
    fi
EOF
)

jira-issues() {
    if [[ -z "$JIRA_ACCOUNT_ID" ]]; then
        echo "JIRA_ACCOUNT_ID is not set. Please set it to your JIRA account ID."
        return 1
    fi

    (
        echo "CTRL-O (open in brower) / CTRL-V (view)"; \
        echo "CTRL-E (edit) / CTRL-t (transition)"; \
        jira issue list "${__JIRA_ISSUE_LIST_OPTS[@]}"
    ) |
    fzf \
        "${__JIRA_FZF_OPTS[@]}" \
        --header-lines 3 \
        --accept-nth 2 \
        --bind "ctrl-o:execute:${__jira_open_browser_bind_cmd}" \
        --bind "ctrl-v:execute(jira issue view {2})+accept" \
        --bind "ctrl-e:execute(jira issue edit {2})+accept" \
        --bind "ctrl-t:execute(jira issue transition {2})+accept"
}

abbr --session ji="jira-issues"
