if type lsd > /dev/null; then
    alias ls="lsd -F"
elif type exa > /dev/null; then
    alias ls=exa
fi

disable r

nvdiff() {
    local git_dir=$(git rev-parse --git-dir 2>/dev/null)
    if [ -z "$git_dir" ]; then
        echo "Not a git repository."
        return 1
    fi

    local target_branch=$1
    if [ -z "$target_branch" ]; then
        target_branch="main"
    fi

    echo "Opening diff view for $target_branch"


    # We have to open some existing file avoid an error that 
    # occurs when involing DiffviewOpen from an empty buffer.
    nvim -c "DiffviewOpen $target_branch --imply-local" "$git_dir/HEAD"
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
