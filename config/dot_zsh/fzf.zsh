if test -d $HOMEBREW_PREFIX/opt/fzf; then
    source $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height=40% --info=inline --layout=reverse --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=$(
    cat <<EOF | tr -d '\n'
    --prompt 'Files> '
    --header 'CTRL-E: Etit / CTRL-V: View / CTRL-O Open in browser / CTRL-T: Toggle Files/Directories'
    --bind 'ctrl-t:transform:[[ ! \$FZF_PROMPT =~ Files ]] &&
              echo "change-prompt(Files> )+reload(fd --type file)" ||
              echo "change-prompt(Directories> )+reload(fd --type directory)"'
    --bind 'ctrl-e:execute(\$EDITOR {})'
    --bind 'ctrl-v:execute(bat --plain --paging=always {})'
    --bind 'ctrl-o:execute-silent(gh browse {})'
    --preview '[[ \$FZF_PROMPT =~ Files ]] && bat --color=always {} || tree -C {}'
EOF
)

# ghq integration
# Function to select a repository using fzf
function __fzf_ghq() {
    local fzf_options=('--select-1' '--exit-0')
    local root=$(ghq root)
    local selected_dir=$(ghq list | fzf --query="$LBUFFER" $fzf_options --preview="ls ${root}/{}")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${root}/${selected_dir}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N __fzf_ghq
bindkey "^]" __fzf_ghq

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

# Function to select a workspace using fzf
function __fzf_amux_session() {
    # Check if current directory is in a amux directory
    if ! amux status >/dev/null 2>&1; then
        # Print error message in red and start a new prompt
        echo "\033[31mError: Not in a amux directory\033[0m"
        zle send-break
        return 1
    fi

    # Get session and format them for display
    # First three line in git worktree list is the main worktree
    local result=$(
        (
            echo "CTRL-D: Delete workspace" &&
            amux session list
        ) | fzf --header-lines 3 \
            --height=40% --layout=reverse --info=inline \
            --preview-window="bottom" \
            --preview="amux session logs {1}" \
            --bind 'enter:accept' \
            --bind 'ctrl-d:print(__delete)+accept' \
            --accept-nth 1)

    if [[ $result == __delete* ]]; then
        local LF=$'\n'
        local target_index=${result#*$LF}
        BUFFER="amux session rm $target_index"
        zle accept-line
    elif [ -n "$result" ]; then
        BUFFER="$result"
    fi
    zle reset-prompt
}

zle -N __fzf_amux_session
bindkey "^o^s" __fzf_amux_session

# Function to search files using ripgrep with fzf
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
function __fzf_rg_fzf() {
    rm -f /tmp/__fzf_rg_fzf-{r,f}
    local rg_prefix="rg --column --line-number --no-heading --color=always --smart-case "
    local initial_query="$LBUFFER"
    BUFFER=""
    fzf --ansi --disabled --query "$initial_query" \
        --height 100% --layout=default \
        --bind "start:reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/__fzf_rg_fzf-f; cat /tmp/__fzf_rg_fzf-r" ||
      echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/__fzf_rg_fzf-r; cat /tmp/__fzf_rg_fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-E EDIT / CTRL-V View / CTRL-O Open in browser / CTRL-T: Switch between ripgrep/fzf' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})' \
        --bind 'ctrl-e:execute($EDITOR {1} +{2})' \
        --bind 'ctrl-v:execute(bat --plain --paging=always {1})' \
        --bind 'ctrl-o:execute-silent(gh browse {1})'
}

zle -N __fzf_rg_fzf
bindkey "^s" __fzf_rg_fzf


# Zoxide integration
# Function to search directories using zoxide with fzf
function __fzf_zoxide() {
    local res
    if [ -n "$LBUFFER" ]; then
        res=$(zoxide query -i -- ${LBUFFER})
    else
        res=$(zoxide query -i)
    fi

    if [ -n "$res" ]; then
        BUFFER="cd \"$res\""
        zle accept-line
    fi
    zle reset-prompt
}

zle -N __fzf_zoxide
bindkey '^g^g' __fzf_zoxide

# wezterm integration

function __fzf_wezterm() {
    wezterm cli list | fzf \
        --height=40% \
        --layout=reverse \
        --info=inline \
        --preview="wezterm cli get-text {3}"
}
