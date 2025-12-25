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
