# wtm integration
# Function to select a workspace using fzf
function __fzf_wtm() {
    # Check if current directory is in a amux directory
    if ! wtm list >/dev/null 2>&1; then
        # Print error message in red and start a new prompt
        echo "\033[31mError: Not in a git repository\033[0m"
        zle send-break
        return 1
    fi

    # Get worktrees and format them for display
    # First three line in git worktree list is the main worktree
    local result=$(
        (
            echo "Enter: Change directory, CTRL-D: Delete workspace" &&
            wtm list
        ) | fzf --header-lines 2 \
            --height=40% --layout=reverse --info=inline \
            --preview-window="bottom" \
            --preview="wtm show {1}" \
            --bind 'enter:accept' \
            --bind 'ctrl-d:print(__delete)+accept' \
            --accept-nth 1)

    if [[ $result == __delete* ]]; then
        local LF=$'\n'
        local target_index=${result#*$LF}
        BUFFER="wtm remove -D $target_index"
        zle accept-line
    elif [ -n "$result" ]; then
        BUFFER="cd \$(wtm show $result --field path)"
        zle accept-line
    fi
    zle reset-prompt
}

zle -N __fzf_wtm
bindkey "^o^w" __fzf_wtm

