alias vim nvim

if set -q TMUX
  alias pbcopy "reattach-to-user-namespace pbcopy"
end

alias ap "ansible-playbook -i hosts/hosts --skip-tags commit_check"

function idea
    open -a "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea" (pwd)
end

function clion
    open -a "/Applications/CLion.app/Contents/MacOS/clion" (pwd)
end
