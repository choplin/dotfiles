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
    __wk_widgets[$key_label]=$widget
}

# Add an existing keybinding to which-key (display only, no zle -N or bindkey)
# Usage: wk-add "Ctrl-T" "fzf: File Search" fzf-file-widget
function wk-add() {
    local key_label="$1" desc="$2" widget="$3"
    __wk_entries+=("$(printf '%-20s │  %s' "$key_label" "$desc")")
    __wk_widgets[$key_label]=$widget
}

function __fzf_which_key() {
    zle -I

    local entries
    entries=$(printf '%s\n' "${__wk_entries[@]}")

    # Build fzf --bind for Ctrl-key navigation
    # First press (empty query): change-query with ^ anchor to filter prefix group
    # Second press (non-empty query): reload with awk to physically filter entries
    # result event auto-accepts when narrowed to 1 match
    local tmpfile=$(mktemp)
    echo "$entries" > "$tmpfile"

    local -a bind_args
    local k fzf_key
    for k in $(echo "$entries" | perl -ne 'print "$1\n" while /\b(Ctrl-\S+)/g' | sort -u); do
        fzf_key="ctrl-$(echo "${k#Ctrl-}" | tr '[:upper:]' '[:lower:]')"
        local cmd="[ -z \"\$FZF_QUERY\" ] && echo \"change-query(^${k} )\" || echo \"reload(awk -v p=\\\"\${FZF_QUERY#^}${k} \\\" 'substr(\\\$0,1,length(p))==p' ${tmpfile})+change-query( )\""
        bind_args+=("--bind" "${fzf_key}:transform:${cmd}")
    done
    bind_args+=("--bind" 'result:transform:[[ $FZF_MATCH_COUNT -eq 1 && -n $FZF_QUERY ]] && echo accept')

    local selected
    selected=$(echo "$entries" | fzf --prompt="Key> " --no-multi --exact --tiebreak=index --height=40% --layout=reverse "${bind_args[@]}")
    rm -f "$tmpfile"

    if [[ -n "$selected" ]]; then
        local selected_key="${selected%% │*}"
        selected_key="${selected_key%"${selected_key##*[! ]}"}"
        local widget=${__wk_widgets[$selected_key]}
        if [[ -n "$widget" ]]; then
            zle "$widget"
            return
        fi
    fi
    zle reset-prompt
}

zle -N __fzf_which_key
bindkey "^ " __fzf_which_key
