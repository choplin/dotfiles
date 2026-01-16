function gibo-fzf() {
  local result=$(
    gibo list \
    | fzf --multi \
        --preview 'gibo dump {} | bat -l gitignore --color=always --style=plain' \
        --preview-window 'right,60%' \
        --border \
        --border-label ' gibo-fzf ' \
        --bind 'tab:toggle+transform-border-label:echo " Selected: {+} "' \
        --bind 'ctrl-p:execute:gibo dump {+} | bat -l gitignore --paging=always' \
        --bind 'ctrl-x:deselect-all+transform-border-label:echo " gibo-fzf "' \
        --header 'Tab: select, Ctrl-X: clear, Ctrl-P: preview, Enter: dump'
  )

  if [[ -n "$result" ]]; then
    gibo dump ${(f)result}
  fi
}
