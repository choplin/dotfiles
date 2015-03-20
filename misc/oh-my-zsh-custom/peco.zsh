function pvim {
    _ghq_pce vim "$*"
}

function pcd {
    _ghq_peco cd "$*"
}

function _ghq_peco {
    local cmd="$1"
    local arg="$2"

    local target
    if [ -n "$arg" ]; then
        target=$(ghq list -p|peco --query "$arg")
    else
        target=$(ghq list -p|peco)
    fi

    if [ -n "$target" ]; then
        eval "'$cmd' $target"
    fi
}
