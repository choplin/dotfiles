pvim() {
    _ghq_fzf vim "$*"
}

pcd() {
    _ghq_fzf cd "$*"
}

pcopy() {
    _ghq_fzf "echo -n" "$*" | pbcopy
}

_ghq_fzf() {
    local cmd="$1"
    local arg="$2"

    local target
    if [ -n "$arg" ]; then
        target=$(ghq list -p|fzf --query "$arg" --select-1)
    else
        target=$(ghq list -p|fzf)
    fi

    if [ -n "$target" ]; then
        eval "$cmd $target"
    fi
}

fzf-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

fshow() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}
