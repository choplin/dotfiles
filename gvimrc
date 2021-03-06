"-----------------------------------------------------------------------------
" Common
"-----------------------------------------------------------------------------
"{{{
"カラースキーム
colorscheme solarized
set background=light
"フォント
if has ('gui_macvim')
    set guifont=Ricty\ Regular:h16
elseif has('win32') || has('win64')
    set guifont=Ricty:h13:b:cSHIFTJIS
else 
    set guifont=Ricty\ Bold\ 12
endif
"ベルを停止
set visualbell t_vb=
set errorbells t_vb=
"初期化
set guioptions&
"ツールバーを非表示
set guioptions-=T
"スクロールバーを非表示
set guioptions-=L
set guioptions-=r
"非GUIのタブを用いる
set guioptions-=e
"メニュー非表示
set guioptions-=m
"}}}
"-----------------------------------------------------------------------------
" Windows
"-----------------------------------------------------------------------------
"{{{
if has('win32') || has('win64')
endif
"}}}
"-----------------------------------------------------------------------------
" Mac
"-----------------------------------------------------------------------------
"{{{
if has ('gui_macvim')
    set iminsert=2
    set transparency=0
    set fuoptions=maxvert,maxhorz
    let $SUDO_ASKPASS="/Applications/MacVim.app/Contents/MacOS/macvim-askpass"
    let $DISPLAY=":0"
endif
"}}}
"-----------------------------------------------------------------------------
" autocmd
"-----------------------------------------------------------------------------
"{{{
augroup MyAutoCmdGUI
    "ウィンドウを最大化して起動
    " Windows
    "if has('win32') || has('win64')
    "    autocmd GUIEnter * simalt ~x
    "elseif has('gui_macvim')
    "    autocmd GUIEnter * set fullscreen
    "endif

    "入力モード時、ステータスラインのカラーを変更
    autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
    autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END
"}}}
"
" singleton.vim {{{
call singleton#enable()
" }}}
