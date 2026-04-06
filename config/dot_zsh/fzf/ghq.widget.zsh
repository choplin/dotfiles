# Function to select a repository using fzf
function __fzf_ghq() {
    local root=$(ghq root)
    local result=$(
        (
            echo "Enter: Insert path, Ctrl-C: cd, Ctrl-D: Delete" &&
            ghq list
        ) | fzf --header-lines 1 \
            --select-1 --exit-0 \
            --preview="ls ${root}/{}" \
            --bind 'enter:accept' \
            --bind 'ctrl-c:print(__cd)+accept' \
            --bind 'ctrl-d:print(__delete)+accept')

    if [[ $result == __cd* ]]; then
        local LF=$'\n'
        local selected_dir=${result#*$LF}
        BUFFER="cd \"${root}/${selected_dir}\""
        zle accept-line
    elif [[ $result == __delete* ]]; then
        local LF=$'\n'
        local selected_dir=${result#*$LF}
        local repo_path="${root}/${selected_dir}"
        local parent_dir=$(dirname "$repo_path")
        print -n "\nDelete ${selected_dir}? [y/N] "
        if read -q; then
            print
            rm -rf "$repo_path"
            print "Deleted: ${repo_path}"
            if [[ -z $(ls -A "$parent_dir") ]]; then
                rmdir "$parent_dir"
                print "Deleted: ${parent_dir}"
            fi
        else
            print "\nCancelled."
        fi
        zle send-break
    elif [ -n "$result" ]; then
        LBUFFER+="${root}/${result}"
    fi

    zle reset-prompt
}

wk-register "Ctrl-]" "GHQ: Repository Selector" __fzf_ghq
