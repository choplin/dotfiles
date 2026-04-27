__wtm_fzf_py="${0:A:h}/wtm-fzf.py"


function __fzf_wtm() {
    if ! wtm list >/dev/null 2>&1; then
        echo "\033[31mError: Not in a git repository\033[0m"
        zle send-break
        return 1
    fi

    local header="Enter: cd  CTRL-D: delete  CTRL-O: open PR | GIT: ↑ahead ↓behind ●dirty"

    # Temp file as one-shot flag: load:transform checks and removes it to reload exactly once
    local flag=$(mktemp)

    local result=$(
        wtm list | awk 'NR==1{print $0"  GIT  PR"} NR>1{print $0"  …    …"}' | fzf \
            --ansi \
            --header "$header" \
            --header-lines 1 \
            --height=40% --layout=reverse --info=inline \
            --preview-window="bottom" \
            --preview="python3 $__wtm_fzf_py preview {1}" \
            --bind "load:transform:[ -f $flag ] && rm -f $flag && echo 'reload:python3 $__wtm_fzf_py enrich'" \
            --bind 'enter:accept' \
            --bind "ctrl-o:execute-silent(cd \$(wtm show {1} --field path) && gh pr view --web 2>/dev/null)" \
            --bind 'ctrl-d:print(__delete)+accept' \
            --accept-nth 1)

    rm -f "$flag" 2>/dev/null

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

wk-register "Ctrl-O Ctrl-W" "Worktree: Selector" __fzf_wtm
