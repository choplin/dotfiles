function fish_prompt --description 'Write out the prompt'
    set -l laststatus $status

    function _is_git_repo
        test -d .git; or git rev-parse --git-dir > /dev/null ^/dev/null
    end

    function _color
        if test $argv[1] -eq 0
            set_color -o green
        else
            set_color -o red
        end
    end

    function _show_ssh_host
        if set -q SSH_CLIENT
            printf '[%s@%s] ' $USER (prompt_hostname)
        else
            echo -n ''
        end
    end

    function _show_path
        if _is_git_repo
            git rev-parse --show-prefix
        else
            prompt_pwd
        end
    end

    function _show_prompt
        set -l user_char '❯'
        set -l root_char '❯❯❯'
        if test (id -u) -eq 0
            echo -n $root_char
        else
            echo -n $user_char
        end
    end

    echo -n -s (_color $laststatus) (_show_ssh_host) (_show_path) (_show_prompt) ' ' (set_color normal)
end
