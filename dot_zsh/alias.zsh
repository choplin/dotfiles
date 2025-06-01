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
    echo "Opening diff view for $1"

    # We have to open some existing file avoid an error that 
    # occurs when involing DiffviewOpen from an empty buffer.
    nvim -c "DiffviewOpen $1 --imply-local" "$git_dir/HEAD"
}
