function __fzf_wezterm() {
    wezterm cli list | fzf \
        --height=40% \
        --layout=reverse \
        --info=inline \
        --preview="wezterm cli get-text {3}"
}

# ToDo: Add keybinding
