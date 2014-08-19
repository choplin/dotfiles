function pvim {
    local target
    if [ $# -gt 0 ]; then
        target=$(ghq list -p|peco --query $@)
    else
        target=$(ghq list -p|peco)
    fi

    if [ -n "$target" ]; then
        echo $target
        vim $target
    fi
}

function pcd {
    local target
    if [ $# -gt 0 ]; then
        target=$(ghq list -p|peco --query $@)
    else
        target=$(ghq list -p|peco)
    fi

    if [ -n "$target" ]; then
        cd $target
    fi
}

# TODO
function pupdate {
}
