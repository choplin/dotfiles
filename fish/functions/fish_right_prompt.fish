function fish_right_prompt
    function _show_git_info
        function _git_branch_name
            echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
        end

        if [ (_git_branch_name) ]
            set -l git_color (set_color 242)
            set -l reponame (basename (git rev-parse --show-toplevel))
            printf "%s%s/git/%s" $git_color $reponame (_git_branch_name)
        end
    end

    function _show_git_status
        function _is_git_dirty
            echo (git status -s --ignore-submodules=dirty ^/dev/null)
        end
        if [ (_is_git_dirty) ]
            for i in (git branch -qv --no-color | string match -r '\*' | cut -d' ' -f4- | cut -d] -f1 | tr , \n)\
 (git status --porcelain | cut -c 1-2 | uniq)
                switch $i
                    case "*[ahead *"
                        set git_status "$git_status"(set_color red)⬆
                    case "*behind *"
                        set git_status "$git_status"(set_color red)⬇
                    case "."
                        set git_status "$git_status"(set_color green)✚
                    case " D"
                        set git_status "$git_status"(set_color red)✖
                    case "*M*"
                        set git_status "$git_status"(set_color green)✱
                    case "*R*"
                        set git_status "$git_status"(set_color purple)➜
                    case "*U*"
                        set git_status "$git_status"(set_color brown)═
                    case "??"
                        set git_status "$git_status"(set_color red)≠
                end
            end
            set -l color (set_color 242)
            printf "%s[%s%s]" $color $git_status $color
        end
    end

    echo -n (_show_git_info) (_show_git_status)
end
