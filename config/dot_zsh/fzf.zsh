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

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

__open_url() {
  case "$OSTYPE" in
    darwin*) /usr/bin/open "$1" ;;
    *)       xdg-open "$1" ;;
  esac
}

local script_dir="${0:A:h}"

for f in "$script_dir"/fzf/*.widget.zsh(.N); do
  source "$f"
done

# Register external keybindings with which-key (display only)
# fzf builtins
wk-add "Ctrl-T" "fzf: File Search" fzf-file-widget
wk-add "Ctrl-R" "fzf: History Search" fzf-history-widget
# fzf-git (Ctrl-G + key)
wk-add "Ctrl-G Ctrl-F" "fzf-git: Files" fzf-git-files-widget
wk-add "Ctrl-G Ctrl-B" "fzf-git: Branches" fzf-git-branches-widget
wk-add "Ctrl-G Ctrl-T" "fzf-git: Tags" fzf-git-tags-widget
wk-add "Ctrl-G Ctrl-R" "fzf-git: Remotes" fzf-git-remotes-widget
wk-add "Ctrl-G Ctrl-H" "fzf-git: Hashes" fzf-git-hashes-widget
wk-add "Ctrl-G Ctrl-S" "fzf-git: Stashes" fzf-git-stashes-widget
wk-add "Ctrl-G Ctrl-L" "fzf-git: Reflogs" fzf-git-lreflogs-widget
wk-add "Ctrl-G Ctrl-E" "fzf-git: Each Ref" fzf-git-each_ref-widget
wk-add "Ctrl-G Ctrl-W" "fzf-git: Worktrees" fzf-git-worktrees-widget
