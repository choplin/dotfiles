if command -v chezmoi > /dev/null 2>&1; then
    chezmoi-edit-fzf() {
        chezmoi edit --watch "$(chezmoi managed -p absolute | fzf)"
    }
fi
