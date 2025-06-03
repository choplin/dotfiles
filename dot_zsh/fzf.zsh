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

function ghq-fzf() {
    local fzf_options=('--select-1' '--exit-0')
    local root=$(ghq root)
    local selected_dir=$(ghq list | fzf --query="$LBUFFER" $fzf_options --preview="ls ${root}/{}")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${root}/${selected_dir}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N ghq-fzf
bindkey "^]" ghq-fzf

function git-worktree-fzf() {
    # Check if current directory is in a git repository
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Print error message in red and start a new prompt
        echo "\033[31mError: Not in a git repository\033[0m"
        zle send-break
        return 1
    fi

    # Get the git repository root
    local git_root=$(git rev-parse --show-toplevel)

    # Get worktrees and format them for display
    # First line in git worktree list is the main worktree
    local worktrees_data=$(git worktree list)
    local selected_worktree=$(echo "$worktrees_data" |
        awk '{print $1}' |
        sed -E '1s|.+|(main) \t&|; 2,$s|.*/\.worktrees/(.*)|\1 \t&|' |
        fzf --query="$LBUFFER" \
            --height=40% --layout=reverse --info=inline \
            --with-nth=1 \
            --delimiter='\t' \
            --preview='ls -la $(echo {2})' |
        awk -F '\t' '{print $2}')

    # Change directory if a worktree was selected
    if [ -n "$selected_worktree" ]; then
        BUFFER="cd ${selected_worktree}"
        zle accept-line
    fi

    zle reset-prompt
}

zle -N git-worktree-fzf
bindkey "^\\" git-worktree-fzf

# Function to search files using ripgrep with fzf
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
function rgf() {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --height 100% --layout=default \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-T: Switch between ripgrep/fzf' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}
