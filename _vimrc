if has("win32") || has("win64")
  set encoding=cp932
endif
scriptencoding utf-8
" <Leader>
let mapleader = ","

if has("win32") || has("win64")
  let vimdir="~/vimfiles/"
else
  let vimdir="~/.vim/"
endif

" load plugins with neobundle.vim
execute "source ".vimdir."vimrc/_vimrc.neobundle"
" plugin settings
execute "source ".vimdir."vimrc/_vimrc.plugin"
"-----------------------------------------------------------------------------
" set
"-----------------------------------------------------------------------------
" {{{
"スワップを作らない
set noswapfile
set backupdir=~/.vim/backup
if version >= 704
  set undodir=~/.vim/undo
endif
"ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer
"左右のカーソル移動で行間移動可能にする。
set whichwrap=h,l,b,s,<,>,[,]
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"タブの代わりに空白文字を挿入する
set expandtab
"シフト移動幅
set shiftwidth=4
"ファイル内の Tab が対応する空白の数
set tabstop=4
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"タブ文字、行末など不可視文字を表示する
set list
"listで表示される文字のフォーマットを指定する
set listchars=tab:▸\ ,extends:<,trail:_
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
"インクリメンタルサーチを行う
set incsearch
"シンタックスハイライトを有効にする
if has("syntax")
  syntax on
endif
"ルーラーを表示
set ruler
set title
"検索時に大文字を含んでいたら大/小を区別
set ignorecase
set smartcase
"Vimgrepで外部grepを使用
if executable('ag')
  set grepprg=ag\ --nogroup\ -iS
  set grepformat=%f:%l:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup
  set grepformat=%f:%l:%m
else
  set grepprg=grep\ -Hnd\ skip\ -r
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
endif
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にする
set hlsearch
"ステータスラインを常に表示
set laststatus=2
"ステータスのところにファイル情報表示
set statusline=%<
set statusline+=\ [%{fnamemodify(getcwd(),':~')}]\ %F\ 
set statusline+=%=
set statusline+=\ %{fugitive#statusline()}%m%r%h%w%y
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}
set statusline+=\ %l,%c\ %P 
" 矩形選択で行末を超えてブロックを選択できるようにする
set virtualedit+=block
"tagファイル読み込み
set tags=./tags,tags
"コマンドの補完候補を一覧表示
set wildmode=list:longest,full
" foldを有効化
set foldenable
set foldmethod=marker
" diff
set diffopt=filler,vertical
" splitは右下
set splitbelow
set splitright
" 変更のあったファイルを自動で読みなおす
set autoread
" 下に余白を残してスクロールする
set scrolloff=5
" BOMをつけない
set nobomb
" タブラベルを常に表示
set showtabline=2
" insert開始時の文字列を削除できるように
set backspace=indent,eol,start
" これをしないと候補選択時に Scratch ウィンドウが開いてしまう 
set completeopt=menuone
" 行番号非表示
set nonumber
"
set backupcopy=yes
" normal mode/command line のみconceal表示をする
set concealcursor=nc

set fileencodings="utf-8,iso-2022-jp-3,euc-jisx0213,guess,ucs-bom,latin1,iso-2022-jp-3,cp932,euc-jisx0213,euc-jp"



"}}}
"-----------------------------------------------------------------------------
" map
"-----------------------------------------------------------------------------
" {{{
" 見た目で行移動
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

"検索語が画面の真ん中に来るようにする
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#z

"タブの作成
nnoremap <C-w>t :<C-u>tabnew<CR>


":でCommand Windowを開く
"nnoremap <sid>(command-line-enter) q:
"xnoremap <sid>(command-line-enter) q:
"nnoremap <sid>(command-line-norange) q:<C-u>

"nmap :  <sid>(command-line-enter)
"xmap :  <sid>(command-line-enter)
"nmap ;  <sid>(command-line-enter)
"xmap ;  <sid>(command-line-enter)
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

"<C-l>でハイライトを止める
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" .vimrc .gvimrcの編集、読み込み
nnoremap <SID>[vim] <Nop>
nmap <Leader>e <SID>[vim]
nnoremap <silent> <SID>[vim]v  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <SID>[vim]g  :<C-u>edit $MYGVIMRC<CR>
nnoremap <silent> <SID>[vim]n  :<C-u>edit $HOME/.vim/vimrc/_vimrc.neobundle<CR>
nnoremap <silent> <SID>[vim]p  :<C-u>edit $HOME/.vim/vimrc/_vimrc.plugin<CR>
" after/ftplugin/{&filetype}.vim ファイルを開く
let $AFTER_FTPLUGIN = vimdir."/after/ftplugin"
nnoremap <silent> <SID>[vim]f :<C-u>execute ":e".$AFTER_FTPLUGIN."/".&filetype.".vim"<CR>
" snippet
nnoremap <silent> <SID>[vim]s :<C-u>NeoSnippetEdit -vertical -split<CR>
nnoremap <silent> <SID>[vim]r :<C-u>NeoSnippetEdit -runtime -vertical -split<CR>

nnoremap <C-W><C-F> <C-W><C-F><C-W><S-L>

" jjでESC
inoremap jj <Esc>
" help
nnoremap <C-h> :<C-u>vertical help 

nnoremap <C-W>t :<C-u>tabnew<CR>:cd<CR>

" imap
inoremap <C-d> <ESC>lxi
inoremap <C-a>  <Home>
inoremap <C-e>  <End>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>

" quickfix
nnoremap <SID>[quickfix] <Nop>
nmap <Leader>c <SID>[quickfix]
nnoremap <silent> <SID>[quickfix]o :<C-u>copen<CR>
nnoremap <silent> <SID>[quickfix]c :<C-u>cclose<CR>

nnoremap <C-n> :<C-u>cnext<CR>
nnoremap <C-p> :<C-u>cprevious<CR>

"}}}
"-----------------------------------------------------------------------------
" autocomd
"-----------------------------------------------------------------------------
" {{{
augroup MyAutoCmd
  autocmd!
  " help
  autocmd FileType help nnoremap <buffer><silent> q :quit<CR>

  " filetypeに合わせた辞書ファイルを読み込み
  autocmd FileType *  execute printf("setlocal dict=$HOME/.vim/dict/%s.dict", &filetype)

  " IME自動制御
  autocmd InsertEnter,CmdwinEnter * set noimdisable
  autocmd InsertLeave,CmdwinLeave * set imdisable
augroup END

" }}}
"-----------------------------------------------------------------------------
" GUI
"-----------------------------------------------------------------------------
" {{{
"+guiでコンパイルされている
try
  if has('gui')
    colorscheme solarized
    set background=light
  else
    colorscheme robokai
  endif
catch
  " only suppress error message
endtry

"gvimとして起動（:guiで起動したときは読み込まれないので注意）
if has('gui_running')
endif
"}}}
"-----------------------------------------------------------------------------
" Windows
"-----------------------------------------------------------------------------
" {{{
"WindowsでCtrl+C Ctrl+V Ctrl+Xを有効にする
if has('win32') || has('win64')
  source $VIMRUNTIME/mswin.vim
  call submode#enter_with('tabnext', 'n', '', '<C-Tab>', ':<C-u>tabnext<CR>')
  nmap <C-v> <C-v>
  nmap <C-a> <C-a>
  nmap <C-z> <C-z>
  inoremap <F7> <Nop>
  if has('gui_running')
    "ウィンドウを最大化して起動
    autocmd MyAutoCmd GUIEnter * simalt ~x
  endif
endif
" }}}
"-----------------------------------------------------------------------------
" Mac
"-----------------------------------------------------------------------------
" {{{
if has('mac')
  "let $PYTHON_DLL = "/usr/local/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib"
endif

" }}}
"-----------------------------------------------------------------------------
" Misc
"-----------------------------------------------------------------------------
" {{{
" tablineを設定{{{
" 各タブページのカレントバッファ名+αを表示
function! s:tabpage_label(n)
  " t:title と言う変数があったらそれを使う
  let title = v:version >= 703 ? gettabvar(a:n, 'title') : ''
  if title !=# ''
    return title
  endif

  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " バッファが複数あったらバッファ数を表示
  let no = len(bufnrs)
  if no is 1
    let no = ''
  endif
  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
  let sp = (no . mod) ==# '' ? '' : ' '  " 隙間空ける

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = fnamemodify(bufname(curbufnr), ":p:t")

  let label = no . mod . sp . fname

  return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' | '  " タブ間の区切り
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  let info = fnamemodify(getcwd(), ":~") . ' '
  return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
endfunction

set tabline=%!MakeTabLine()
"}}}
" numberとrelativenumberを切り替え {{{
if version >= 703
  nnoremap  <silent><expr> <Leader>n ToggleNumberOption()
  function! ToggleNumberOption()
    if &number
      set nonumber
      set relativenumber
    elseif &relativenumber
      set nonumber
      set norelativenumber
    else
      set number
      set norelativenumber
    endif
  endfunction
endif
" }}}
" cursorcolumn cursorlineを切り替え {{{
" nnoremap  <silent><expr> <Leader>c ToggleCursor()
function! ToggleCursor()
  if &cursorcolumn || &cursorline
    set nocursorcolumn
    set nocursorline
  else
    set cursorcolumn
    set cursorline
  endif
endfunction
" }}}
" GitLogViewer {{{
" " Inspired by ujihisa's vimrc
function! s:GitLogViewer()
  new
  VimProcRead git log -u 'ORIG_HEAD..HEAD'
  set filetype=git
  set buftype=nofile
  setlocal foldmethod=expr
  setlocal foldexpr=getline(v:lnum)=~'^commit'?'>1':getline(v:lnum+1)=~'^commit'?'<1':'='
  setlocal foldtext=FoldTextOfGitLog()
endfunction
" git log表示時の折りたたみ用
function! FoldTextOfGitLog()
  let month_map = {
    \ 'Jan' : '01',
    \ 'Feb' : '02',
    \ 'Mar' : '03',
    \ 'Apr' : '04',
    \ 'May' : '05',
    \ 'Jun' : '06',
    \ 'Jul' : '07',
    \ 'Aug' : '08',
    \ 'Sep' : '09',
    \ 'Oct' : '10',
    \ 'Nov' : '11',
    \ 'Dec' : '12',
    \ }

  if getline(v:foldstart) !~ '^commit'
    return getline(v:foldstart)
  endif

  if getline(v:foldstart + 1) =~ '^Author:'
    let author_lnum = v:foldstart + 1
  elseif getline(v:foldstart + 2) =~ '^Author:'
    " commitの次の行がMerge:の場合があるので
    let author_lnum = v:foldstart + 2
  else
    " commitの下2行がどちらもAuthor:で始まらなければ諦めて終了
    return getline(v:foldstart)
  endif

  let date_lnum = author_lnum + 1
  let message_lnum = date_lnum + 2

  let author = matchstr(getline(author_lnum), '^Author: \zs.*\ze <.\{-}>')
  let date = matchlist(getline(date_lnum), ' \(\a\{3}\) \(\d\{1,2}\) \(\d\{2}:\d\{2}:\d\{2}\) \(\d\{4}\)')
  let message = getline(message_lnum)

  let month = date[1]
  let day = printf('%02s', date[2])
  let time = date[3]
  let year = date[4]

  let datestr = join([year, month_map[month], day], '-')

  return join([datestr, time, author, message], ' ')
endfunctio

command! GitLogViewer call s:GitLogViewer()

" }}}
" {{{ kobito
function! s:open_kobito(...)
    if a:0 == 0
        call system('open -a Kobito '.expand('%:p'))
    else
        call system('open -a Kobito '.join(a:000, ' '))
    endif
endfunction

" 引数のファイル(複数指定可)を Kobitoで開く
" （引数無しのときはカレントバッファを開く
command! -nargs=* Kobito call s:open_kobito(<f-args>)
" Kobito を閉じる
command! -nargs=0 KobitoClose call system("osascript -e 'tell application \"Kobito\" to quit'")
" Kobito にフォーカスを移す
command! -nargs=0 KobitoFocus call system("osascript -e 'tell application \"Kobito\" to activate'")
" }}}
" html2slim
function! Html2Slim(html)
  if !executable("html2slim")
    return ""
  endif
  let input  = tempname()
  call writefile(split(a:html, "\n"), input)
  let output = tempname()
  call system(printf("html2slim %s %s", input, output))
  return join(readfile(output), "\n")
endfunction

" Capture {{{
command!
      \ -nargs=1
      \ -complete=command
      \ Capture
      \ call Capture(<f-args>)

function! Capture(cmd)
  redir => result
  silent execute a:cmd
  redir END

  let bufname = 'Capture: ' . a:cmd
  new
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  silent file `=bufname`
  silent put =result
  1,2delete _
endfunction
" }}}
" }}}

" vim:ts=2 st=2 sw=2
