if test -d $HOMEBREW_PREFIX/opt/fzf; then
    source $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height=40% --info=inline --layout=reverse"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS=$(
    cat <<EOF | tr -d '\n'
    --prompt 'Files> '
    --header 'CTRL-T: Switch between Files/Directories'
    --bind 'ctrl-t:transform:[[ ! \$FZF_PROMPT =~ Files ]] &&
              echo "change-prompt(Files> )+reload(fd --type file)" ||
              echo "change-prompt(Directories> )+reload(fd --type directory)"'
    --preview '[[ \$FZF_PROMPT =~ Files ]] && bat --color=always {} || tree -C {}'
EOF
)

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

function __fzf_my_git_worktrees() {
    # Check if current directory is in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Print error message in red and start a new prompt
        echo "\033[31mError: Not in a git repository\033[0m"
        zle send-break
        return 1
    fi

    local preview=$(
        cat <<EOF
    local dir={1}
    echo \$dir
    git -C "\$dir" -c color.status=$(__fzf_git_color .) status --short --branch
    echo
    git -C "\$dir" log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s'
EOF
    )

    # Get the git repository root
    local git_root=$(git rev-parse --show-toplevel)

    # Get worktrees and format them for display
    # First line in git worktree list is the main worktree
    local selected_worktree=$(git worktree list |
        awk '{print $1 "\t" $3}' |
        fzf --query="$LBUFFER" \
            --border-label '🌴 Worktrees ' \
            --height=40% --layout=reverse --info=inline \
            --with-nth=2 \
            --accept-nth=1 \
            --delimiter='\t' \
            --preview-window="bottom" \
            --preview="$preview")

    # Change directory if a worktree was selected
    if [ -n "$selected_worktree" ]; then
        BUFFER="cd ${selected_worktree}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N __fzf_my_git_worktrees
bindkey "^\\" __fzf_my_git_worktrees

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
        --header 'CTRL-T: Switch between ripgrep/fzf' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
}

zle -N __fzf_rg_fzf
bindkey "^s" __fzf_rg_fzf
