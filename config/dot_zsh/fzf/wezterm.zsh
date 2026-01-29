# WezTerm pane selector with fzf preview
# Switch to any pane across all tabs with live preview
function __fzf_wezterm_pane() {
    local panes
    panes=$(wezterm cli list --format json 2>/dev/null)

    if [[ -z "$panes" || "$panes" == "[]" ]]; then
        echo "\033[31mError: No WezTerm panes found\033[0m"
        zle send-break
        return 1
    fi

    # Format: pane_id<TAB>display_string
    # display_string: [active_marker][Tab:id] title cwd
    local result
    result=$(echo "$panes" | jq -r '.[] | "\(.pane_id)|\(.tab_id)|\(.is_active)|\(.title)|\(.cwd | sub("file://"; ""))"' | \
        awk -F'|' '{
            active = ($3 == "true") ? "* " : "  "
            cwd = $5
            gsub(/\/Users\/[^\/]+/, "~", cwd)
            printf "%s\t%s[Tab:%s] %-30s %s\n", $1, active, $2, $4, cwd
        }' | \
        fzf --height=100% --layout=reverse --info=inline \
            --header="Enter: Switch to pane" \
            --with-nth=2.. \
            --preview='wezterm cli get-text --pane-id {1}' \
            --preview-window="bottom:70%:follow"
    )

    if [[ -n "$result" ]]; then
        local pane_id
        pane_id=$(echo "$result" | cut -f1)
        wezterm cli activate-pane --pane-id "$pane_id"
    fi
    zle reset-prompt
}

zle -N __fzf_wezterm_pane
bindkey "^o^p" __fzf_wezterm_pane
