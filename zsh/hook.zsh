function prompt_pwd() {
    local current_dir
    local git_root=${PWD}
    while true; do
        if [[ -e ${git_root}/.git ]]; then
            current_dir="${PWD#${git_root:h}/}"
            break
        fi
        if [[ ${git_root} == / ]]; then
            current_dir=${(%):-%~}
            break
        fi
        git_root=${git_root:h}
    done

    local separator=/
    local -i dir_length=1
    if [[ ${dir_length} -gt 0 || ${separator} != / ]]; then
        local current_dirs=("${(@s:/:)current_dir}")
        if (( dir_length > 0 && ${#current_dirs} > 2 )); then
            current_dirs[2,-2]=("${(@M)current_dirs[2,-2]##.#?(#c,${dir_length})}")
        fi
        separator=${(e)separator}
        current_dir="${(@pj:$separator:)current_dirs}"
    fi
    print -Rn ${current_dir}
}

autoload -Uz add-zsh-hook

function precmd_hook() {
    echo -ne "\e]0;$(prompt_pwd $(pwd))\a"
}
add-zsh-hook precmd precmd_hook


excluded_cmd=("ls" "cd" "pwd")
function preexec_hook() {
    if ! (($excluded_cmd[(Ie)${1}])); then
        echo -ne "\e]0;${1}\a"
    fi
}
add-zsh-hook preexec preexec_hook
