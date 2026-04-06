# Which-key: keybinding registry and fzf picker
# Must be loaded before other files that call wk-register

typeset -ga __wk_entries=()
typeset -gA __wk_widgets=()

# Register a keybinding with which-key
# Usage: wk-register "Ctrl-G Ctrl-I" "GitHub: My Issues" __fzf_gh_my_issues
function wk-register() {
    local key_label="$1" desc="$2" widget="$3"

    zle -N "$widget"

    # Convert human-readable key to bindkey sequence
    # "Ctrl-G Ctrl-I" → "^g^i", "Ctrl-Space" → "^ ", "Ctrl-]" → "^]"
    local bindkey_seq
    bindkey_seq=$(echo "$key_label" | perl -pe 's/Ctrl-Space/^ /g; s/Ctrl-(.)/^\L$1/g; s/ +(?=\^)//g')
    bindkey "$bindkey_seq" "$widget"

    __wk_entries+=("$(printf '%-20s │  %s' "$key_label" "$desc")")
    __wk_widgets["$key_label"]="$widget"
}

function __fzf_which_key() {
    zle -I

    local entries
    entries=$(printf '%s\n' "${__wk_entries[@]}" | sort)

    # Build fzf --bind for Ctrl-key navigation
    # First press (empty query): filter to prefix group
    # Second press (query has prefix): append key and accept
    local -a bind_args
    local k fzf_key
    for k in $(echo "$entries" | perl -ne 'print "$1\n" while /\b(Ctrl-\S+)/g' | sort -u); do
        fzf_key="ctrl-$(echo "${k#Ctrl-}" | tr '[:upper:]' '[:lower:]')"
        local cmd='[ -z "$FZF_QUERY" ] && echo "change-query('"$k"' )" || printf "change-query(%s'"$k"')+accept" "$FZF_QUERY"'
        bind_args+=("--bind" "${fzf_key}:transform:${cmd}")
    done

    local selected
    selected=$(echo "$entries" | fzf --prompt="Key> " --no-multi --exact --height=40% --layout=reverse "${bind_args[@]}")

    if [[ -n "$selected" ]]; then
        local selected_key="${selected%% │*}"
        selected_key="${selected_key%% }"
        local widget="${__wk_widgets[$selected_key]}"
        if [[ -n "$widget" ]]; then
            zle "$widget"
            return
        fi
    fi
    zle reset-prompt
}

wk-register "Ctrl-Space" "Which Key: Show Keybindings" __fzf_which_key
