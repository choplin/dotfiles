function prompt_pwd() {
    local current_dir
    local project_root=${PWD}
    while true; do
        if [[ -e ${project_root}/.git ]] \
            || [[ -e ${project_root}/settings.gradle ]] \
            || [[ -e ${project_root}/settings.gradle.kts ]]; then
            current_dir="${PWD#${project_root:h}/}"
            break
        fi
        if [[ ${project_root} == / ]]; then
            current_dir=${(%):-%~}
            break
        fi
        project_root=${project_root:h}
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
    local cmd="${1[(w)1]}"
    if [[ "${cmd}" = "vim" ]]; then
        echo -ne "\e]0;vim:$(prompt_pwd $(pwd))\a"
    elif ! (($excluded_cmd[(Ie)${cmd}])); then
        echo -ne "\e]0;${1}\a"
    fi
}
add-zsh-hook preexec preexec_hook
