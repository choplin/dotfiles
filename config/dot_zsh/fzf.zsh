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

local script_dir="${0:A:h}"

for f in "$script_dir"/fzf/*.zsh(.N); do
  source "$f"
done
