## Alias configuration {{{

# expand aliases before completing
setopt complete_aliases     # aliased ls needs if file/dir completions work

# lsとpsの設定 {{{
# ls: できるだけGNU lsを使う。
# ps: 自分関連のプロセスのみ表示。
case $(uname) in
    *BSD|Darwin)
        if [ -x "$(which gnuls)" ]; then
            alias ls="gnuls"
        fi
        ;;
    SunOS)
        if [ -x "`which gls`" ]; then
            alias ls="gls"
        fi
        ;;
    *)
        ;;
esac

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -v -F -G -w"
    ;;
linux*)
    alias ls="ls -v -F --color"
    ;;
esac

alias la="ls -A"
alias ll="ls -l"
# }}}

# ページャーを使いやすくする。
# grep -r def *.rb L -> grep -r def *.rb |& lv
alias -g L="|& $PAGER"
# grepを使いやすくする。
alias -g G='| grep'

# ファイル操作を確認する。
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# git
alias gst="git st -s -b && git --no-pager stash list"
alias gch='git cherry -v'
alias glgg='git logg'
alias glg='git logg | head'
# }}}
## Environment variable configuration {{{
# LANG
export LANG=ja_JP.UTF-8
# }}}
## Default shell configuration {{{
#

# ディレクトリ移動{{{
## ディレクトリ名だけでcdする。
setopt auto_cd
## cdで移動してもpushdと同じようにディレクトリスタックに追加する。
setopt auto_pushd
## カレントディレクトリ中に指定されたディレクトリが見つからなかった場合に
## 移動先を検索するリスト。
cdpath=(~)
## ディレクトリが変わったらディレクトリスタックを表示。
chpwd_functions=($chpwd_functions dirs)
function chpwd { #{{{
    #ディレクトリ移動したとき、lsする。
    #ファイル量が多いと、上下5ファイルだけ表示
    if [ 150 -le $(ls |wc -l ) ] ;then
        ls |head -n 5
    echo '...'
        ls |tail -n 5
        echo "$(ls |wc -l ) files exist"
    else
        ls -v -F
    fi
}
# }}}
#}}}

# command correct edition before each completion attempt
setopt correct
# compacked complete list display
setopt list_packed
# no remove postfix slash of command line
setopt noautoremoveslash
# no beep sound when complete list displayed
setopt nolistbeep
# 補完で末尾に補われた / が自動的に 削除される
setopt auto_remove_slash
# 既にpushdしたディレクトリはダブらせ ずにディレクトリスタックの先頭に持って来る
setopt pushd_ignore_dups
# カーソル位置は保持したままファ イル名一覧を順次その場で表示する
setopt always_last_prompt
# others
setopt auto_menu auto_name_dirs 
setopt rm_star_silent sun_keyboard_hack
setopt list_types
setopt cdable_vars sh_word_split auto_param_keys
unsetopt ignoreeof
# }}}
## Keybind configuration {{{
bindkey -e
# }}}
## Command history configuration {{{
## ヒストリを保存するファイル
HISTFILE=~/.zsh_history
## メモリ上のヒストリ数。
## 大きな数を指定してすべてのヒストリを保存するようにしている。
HISTSIZE=10000000
## 保存するヒストリ数
SAVEHIST=$HISTSIZE
## 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups     # ignore duplication command history list
## スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space
## すぐにヒストリファイルに追記する。
setopt inc_append_history
## zshプロセス間でヒストリを共有する。
setopt share_history
## ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
## C-sでのヒストリ検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
# }}}
## Completion configuration {{{
fpath=($HOME/.oh-my-zsh/custom/functions /usr/local/share/zsh/functions /usr/local/share/zsh/site-functions /usr/local/share/zsh-completions ${fpath})
autoload -U compinit
compinit
# 補完方法毎にグループ化する。{{{
# 補完方法の表示方法
#   %B...%b: 「...」を太字にする。
#   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
#}}}
# 補完侯補をメニューから選択する。{{{
# select=2: 補完候補を一覧から選択する。
#           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
#}}}
# 補完候補に色を付ける。#{{{
# "": 空文字列はデフォルト値を使うという意味。
zstyle ':completion:*:default' list-colors ""
#}}}
# 補完候補がなければより曖昧に候補を探す。{{{
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
#}}}
# 補完方法の設定。指定した順番に実行する。{{{
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer \
    _oldlist _complete _match _history _ignored _approximate _prefix
#}}}
# setting {{{
# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
# 詳細な情報を使う。
zstyle ':completion:*' verbose yes
# sudo時にはsudo用のパスも使う。
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# カーソル位置で補完する。
setopt complete_in_word
# globを展開しないで候補の一覧から補完する。
setopt glob_complete
# 補完時にヒストリを自動的に展開する。
setopt hist_expand
# 補完候補がないときなどにビープ音を鳴らさない。
setopt no_beep
# 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
# }}}
# mosh {{{
compdef mosh=ssh
# }}}
# }}}
## zsh editor {{{
autoload zed
# }}}
## terminal configuration {{{
unset LSCOLORS
case "${TERM}" in
xterm)
    export TERM=xterm-color
    ;;
kterm)
    export TERM=kterm-color
    # set BackSpace control character
    stty erase
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors \
        'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac
# }}}
## load user .zshrc configuration file {{{
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# }}}
## load user function files {{{
fpath=($HOME/.zsh/functions ${fpath})
# }}}
# 展開 {{{
## --prefix=~/localというように「=」の後でも
## 「~」や「=コマンド」などのファイル名展開を行う。
setopt magic_equal_subst
## 拡張globを有効にする。
## glob中で「(#...)」という書式で指定する。
setopt extended_glob
## globでパスを生成したときに、パスがディレクトリだったら最後に「/」をつける。
setopt mark_dirs
# }}}
# ジョブ {{{
## jobsでプロセスIDも出力する。
setopt long_list_jobs
# }}}
# 実行時間 {{{
## 実行したプロセスの消費時間が3秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
REPORTTIME=3
# }}}
# 単語 {{{
## 「/」も単語区切りとみなす。
WORDCHARS=${WORDCHARS:s,/,,}
## 「|」も単語区切りとみなす。
WORDCHARS="${WORDCHARS}|"
# }}}
