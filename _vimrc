if has("win32") || has("win64")
  set encoding=cp932
endif
scriptencoding utf-8
"-----------------------------------------------------------------------------
" Vundle
"-----------------------------------------------------------------------------
" {{{
if has('vim_starting')
  set nocompatible
  if has("win32") || has("win64")
    set rtp+=~/vimfiles/neobundle.vim/ 
    helptags ~/vimfiles/neobundle.vim/doc
    call neobundle#rc('~/vimfiles/bundle/')
  else
    set rtp+=~/.vim/neobundle.vim/ 
    helptags ~/.vim/neobundle.vim/doc
    call neobundle#rc()
  endif

  filetype plugin on
  filetype indent on
endif
" original repos on github
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/tsukkee/unite-tag.git'
NeoBundle 'git://github.com/tsukkee/unite-help.git'
NeoBundle 'git://github.com/h1mesuke/unite-outline.git'
NeoBundle 'git://github.com/ujihisa/unite-launch.git'
NeoBundle 'git://github.com/ujihisa/unite-colorscheme.git'
NeoBundle 'git://github.com/ujihisa/unite-font.git'
NeoBundle 'git://github.com/sgur/unite-qf.git'
NeoBundle 'git://github.com/thinca/vim-unite-history.git'
NeoBundle 'git://github.com/basyura/unite-rails.git'
NeoBundle 'git://github.com/hakobe/unite-script.git'
NeoBundle 'git://github.com/tacroe/unite-alias.git'

NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/clang_complete.git'
NeoBundle 'git://github.com/Shougo/vim-vcs.git'

NeoBundle 'git://github.com/tyru/open-browser.vim.git'
NeoBundle 'git://github.com/tyru/urilib.vim.git'
NeoBundle 'git://github.com/tyru/caw.vim.git'
NeoBundle 'git://github.com/tyru/restart.vim.git'

NeoBundle 'git://github.com/ujihisa/shadow.vim.git'
NeoBundle 'git://github.com/ujihisa/neco-look.git'
NeoBundle 'git://github.com/ujihisa/vimshell-ssh.git'
NeoBundle 'git://github.com/ujihisa/neco-ghc.git'
NeoBundle 'git://github.com/ujihisa/tabpagecolorscheme.git'

NeoBundle 'git://github.com/thinca/vim-ref.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/thinca/vim-qfreplace.git'
NeoBundle 'git://github.com/thinca/vim-ambicmd.git'
NeoBundle 'git://github.com/thinca/vim-localrc.git'
NeoBundle 'git://github.com/thinca/vim-ft-vim_fold.git'
NeoBundle 'git://github.com/thinca/vim-openbuf.git'
NeoBundle 'git://github.com/thinca/vim-prettyprint.git'

NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'git://github.com/tpope/vim-fugitive.git'
NeoBundle 'git://github.com/tpope/vim-haml.git'

NeoBundle 'git://github.com/mattn/zencoding-vim.git'
NeoBundle 'git://github.com/mattn/gist-vim.git'
NeoBundle 'git://github.com/mattn/webapi-vim.git'
NeoBundle 'git://github.com/mattn/googletasks-vim.git'
NeoBundle 'git://github.com/mattn/learn-vimscript.git'
NeoBundle 'git://github.com/mattn/wwwrenderer-vim.git'

NeoBundle 'git://github.com/t9md/vim-textmanip.git'
NeoBundle 'git://github.com/t9md/vim-surround_custom_mapping.git'
NeoBundle 'git://github.com/t9md/vim-nerdtree_plugin_collections.git'
NeoBundle 'git://github.com/t9md/vim-quickhl.git'

NeoBundle 'git://github.com/jceb/vim-orgmode.git'
NeoBundle 'git://github.com/motemen/hatena-vim.git'
NeoBundle 'git://github.com/h1mesuke/vim-alignta.git'
NeoBundle 'git://github.com/kchmck/vim-coffee-script.git'
NeoBundle 'git://github.com/yko/mojo.vim.git'
NeoBundle 'git://github.com/plasticboy/vim-markdown.git'
NeoBundle 'git://github.com/c9s/perlomni.vim.git'
NeoBundle 'git://github.com/jceb/vim-hier.git'
NeoBundle 'git://github.com/tsukkee/lingr-vim.git'
"NeoBundle 'git://github.com/nvie/vim-rst-tables.git'
NeoBundle 'git://github.com/choplin/vim-rst-tables.git'
NeoBundle 'git://github.com/kana/vim-submode.git'
"NeoBundle 'git://github.com/fuenor/qfixhowm.git'
NeoBundle 'git://github.com/soh335/vim-ref-jquery.git'
NeoBundle 'git://github.com/choplin/unite-vim_hacks.git'

NeoBundle 'git://github.com/cschlueter/vim-wombat.git'
NeoBundle 'git://github.com/altercation/vim-colors-solarized.git'
NeoBundle 'git://github.com/therubymug/vim-pyte.git'
NeoBundle 'molokai'
NeoBundle 'robokai'
NeoBundle 'newspaper.vim'

NeoBundle 'a.vim'
NeoBundle 'IndentAnything'
NeoBundle 'Simple-Javascript-Indenter'
NeoBundle 'Javascript-syntax-with-Ajax-Support'
NeoBundle 'vimwiki'
"}}}
"-----------------------------------------------------------------------------
" set
"-----------------------------------------------------------------------------
" {{{
"バックアップ、スワップを作らない
set nobackup
set noswapfile
"ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer 
"左右のカーソル移動で行間移動可能にする。
set whichwrap=h,l,b,s,<,>,[,]
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"水平タブ系の設定==============================================
"デフォルト設定。結局runtime/indentの設定のほうで、ファイルごとに切り替える
"タブの代わりに空白文字を挿入する
set expandtab
"シフト移動幅
set shiftwidth=4
"ファイル内の <Tab> が対応する空白の数
set tabstop=4
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"タブ文字、行末など不可視文字を表示する
set list
"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>-,extends:<,trail:_
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
"インクリメンタルサーチを行う
set incsearch
"相対行番号を表示する
set relativenumber
"シンタックスハイライトを有効にする
if has("syntax")
  syntax on
endif
"カレント行、列をハイライトする
"set cursorline
"set cursorcolumn
"ルーラーを表示
set ruler
set title
"検索時に大文字を含んでいたら大/小を区別
set ignorecase
set smartcase
"Vimgrepで外部grepを使用
set grepprg=grep\ -nH
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にする
set hlsearch
" ステータスエリア関係
"ステータスラインを常に表示
set laststatus=2
"ステータスのところにファイル情報表示
set statusline=%<
set statusline+=[%n]%F\ 
set statusline+=%{fugitive#statusline()}
set statusline+=%=
set statusline+=\ %m%r%h%w%y
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}
set statusline+=\ %l,%c\ %P 
" 文字コード関連""""""""""""""""""""""""""""""""""""""""""
" 文字コードの自動解釈の優先順位
set fileencodings=utf-8,cp932,euc-jp
" 改行コードの解釈優先順位
set fileformats=unix,dos
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

set splitbelow
set splitright

" 変更のあったファイルを自動で読みなおす
set autoread

" 下に余白を残してスクロールする
set scrolloff=5

" ファイルのある位置にchdirする
" set autochdir

" BOMをつけない
set nobomb

"タブラベルを常に表示
set showtabline=2
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
"検索語が画面の真ん中に来るようにする †
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#z

"タブの作成
nnoremap <C-w>t :<C-u>tabnew<CR>


":でCommand Windowを開く
nnoremap <sid>(command-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

nmap :  <sid>(command-line-enter)
xmap :  <sid>(command-line-enter)
nmap ;  <sid>(command-line-enter)
xmap ;  <sid>(command-line-enter)

"<C-l>でハイライトを止める
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" .vimrc .gvimrcの編集、読み込み
nnoremap <Leader>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <Leader>eg  :<C-u>edit $MYGVIMRC<CR>
nnoremap <Leader>sv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <Leader>sg :<C-u>source $MYGVIMRC<CR>

nnoremap <C-W><C-F> <C-W><C-F><C-W><S-L>

" ウィンドウ移動時にサイズを自動調整
nnoremap <C-w>h <C-w>h:call <SID>good_width()<Cr>
nnoremap <C-w>l <C-w>l:call <SID>good_width()<Cr>
nnoremap <C-w>H <C-w>H:call <SID>good_width()<Cr>
nnoremap <C-w>L <C-w>L:call <SID>good_width()<Cr>
function! s:good_width()
  if winwidth(0) < 84
    vertical resize 84
  endif
endfunction

" jjでESC
inoremap jj <Esc>

" <Leader>
map , <Leader>
"}}}
"-----------------------------------------------------------------------------
" autocomd
"-----------------------------------------------------------------------------
" {{{
augroup MyAutoCmd
  autocmd!
  "日本語入力をリセット
  autocmd BufNewFile,BufRead * set iminsert=0
  "タブ幅をリセット
  autocmd BufNewFile,BufRead * set tabstop=4 shiftwidth=4

  "入力モード時、ステータスラインのカラーを変更
  autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
  autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90

  " Command Window
  autocmd CmdwinEnter * nnoremap <buffer><silent> <Esc> :quit<CR>
  autocmd CmdwinEnter * inoremap <buffer> <Leader><Leader> ~

  " help
  autocmd FileType help nnoremap <buffer><silent> q :quit<CR>

  " Windowを移動した時にファイルを読みなおす(更新がある場合)
  autocmd WinEnter * checktime

  " filetypeに合わせた辞書ファイルを読み込み
  autocmd FileType *  execute printf("setlocal dict=$HOME/.vim/dict/%s.dict", &filetype)
augroup END

"全角スペースを視覚化
if has('syntax')
  syntax enable
  function! ActivateInvisibleIndicator()
    highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=#FF0000
    match ZenkakuSpace /　/
  endfunction
  augroup InvisibleIndicator
    autocmd!
    autocmd BufEnter * call ActivateInvisibleIndicator()
  augroup END
endif

"IME自動制御
augroup InsModeAu
  autocmd!
  autocmd InsertEnter,CmdwinEnter * set noimdisable
  autocmd InsertLeave,CmdwinLeave * set imdisable
augroup END

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> q :<C-u>quit<CR>
  "nnoremap <buffer> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"

  " Completion.
  "inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  startinsert!
endfunction
" }}}
"-----------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------
" {{{
" matchit {{{
source $VIMRUNTIME/macros/matchit.vim
" }}}
" NERDTree {{{
noremap <silent> <Leader>nt :<C-u>NERDTreeToggle<CR>
let g:NERDTreeAutoCenter=1
let g:NERDTreeChDirMode=1
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeHijackNetrw=0
augroup MyNertTree
  autocmd!
  autocmd FileType nerdtree nnoremap <buffer> q :NERDTreeClose<CR>
  autocmd FileType nerdtree nnoremap <buffer> <Leader>nb :<C-u>Bookmark 
  autocmd FileType nerdtree nnoremap <buffer> <Leader>nc :<C-u>ClearBookmark<CR>
augroup END
" }}}
" taglist {{{
let Tlist_Show_One_File = 1               "現在編集中のソースのタグしか表示しない 
let Tlist_Exit_OnlyWindow = 1             "taglistのウィンドーが最後のウィンドーならばVimを閉じる 
let Tlist_Use_Right_Window = 1            "右側でtaglistのウィンドーを表示 
noremap <silent> <Leader>tl :TlistToggle<cr>  "taglistを開くショットカットキー
" }}}
" neocomplcache {{{
"Vimデフォルトのオムニ補完を置き換え
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete() 
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" スニペットファイルの配置場所
if has("win32") || has("win64")
  let g:neocomplcache_snippets_dir =  '~/vimfiles/snippets'
else
  let g:neocomplcache_snippets_dir =  '~/.vim/snippets'
endif

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

nnoremap <Leader>es :<C-u>call EditSnippesWithTab({'mode':'user'})<CR>
nnoremap <Leader>er :<C-u>call EditSnippesWithTab({'mode':'runtime'})<CR>
function! EditSnippesWithTab(opt)
  let ftype = &filetype
  execute 'vsplit'
  enew
  execute 'NeoComplCacheEdit'.(a:opt.mode == 'runtime' ? 'Runtime' : '').'Snippets '.ftype
endfunction
" }}}
" unite.vim {{{
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 縦分割で開く
let g:unite_enable_split_vertically=1

nnoremap <SID>[unite] <Nop>
nmap <Leader>u <SID>[unite]
nnoremap <silent> <SID>[unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> <SID>[unite]u :<C-u>Unite bookmark buffer file_mru<CR>
nnoremap <silent> <SID>[unite]a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> <SID>[unite]g :<C-u>Unite grep:.:-nHR:
nnoremap <silent> <SID>[unite]l :<C-u>Unite -no-quit line<CR>
nnoremap <silent> <SID>[unite]o :<C-u>Unite outline<CR>
nnoremap <silent> <SID>[unite]q :<C-u>Unite -no-quit qf<CR>
nnoremap <silent> <SID>[unite]f :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> <SID>[unite]s :<C-u>Unite source<CR>

nnoremap <silent> <C-h> :<C-u>Unite help<CR>

call unite#custom_default_action('source/bookmark/directory', 'rec/async')

" タグジャンプをunite-tagsで置き換え
autocmd BufEnter *
\   if empty(&buftype)
\|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
\|  endif

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.

  nmap <buffer> <ESC>      <Plug>(unite_exit)
  imap <buffer> jj      <Plug>(unite_insert_leave)

  " <C-l>: manual neocomplcache completion.
  inoremap <buffer> <C-l>  <C-x><C-u><C-p><Down>
endfunction"}}}

let g:unite_launch_apps = [
\ 'rake',
\ 'make',
\ 'git pull',
\ 'git push']

" }}}
" unite-transparency {{{
let s:unite_source = {'name': 'transparency', 'action_table': {'*': {} }}
function! s:unite_source.gather_candidates(args, context)
  return map(range(0, 100, 4), '{
        \ "word": v:val,
        \ "source": "transparency",
        \ "kind": "command",
        \ "action__command": "set transparency=" . v:val,
        \ }')
endfunction
let s:unite_source.action_table['*'].preview = {
      \ 'description': 'preview this transparency', 'is_quit': 0 }
function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction
call unite#define_source(s:unite_source)
" }}}
" Hatena.vim {{{
let g:hatena_user='choplin'
" }}}
" quickrun {{{
unlet! g:quickrun_config
let g:quickrun_config = {
      \ 'sql':{
      \     'command': 'psql',
      \     'cmdopt': '-d postgres',
      \     'exec': '%c %o -f %s',
      \ },
      \ 'markdown':{
      \     'outputter': 'browser',
      \ },
      \ 'rst':{
      \     'command': 'rst2html.py',
      \     'cmdopt': '--template postgres',
      \     'exec': '%c %o s',
      \     'outputter': 'browser',
      \ },
      \}

let g:quickrun_no_default_key_mappings = 1
nnoremap <SID>[quickrun] <Nop>
vnoremap <SID>[quickrun] <Nop>
nmap <Leader>q <SID>[quickrun]
vmap <Leader>q <SID>[quickrun]
" 出力先別にショートカットキーを設定する
for [key, com] in items({
      \   '<SID>[quickrun]q' : '>error -success buffer -error unite',
      \   '<SID>[quickrun]m' : '>message',
      \   '<SID>[quickrun]s' : '-runner shell',
      \   '<SID>[quickrun]b' : '>buffer',
      \   '<SID>[quickrun]a' : '>>buffer',
      \ })
  execute 'nnoremap <silent>' key ':QuickRun' com '-mode n<CR>'
  execute 'vnoremap <silent>' key ':QuickRun' com '-mode v<CR>'
endfor

function! s:register_unite_qf_outputter_module()
  let l:outputter = quickrun#outputter#buffered#new()
  let l:outputter.config = {
        \   'errorformat': '&errorformat',
        \   'arg': '',
        \ }

  function! l:outputter.finish(session)
    try
      let errorformat = &l:errorformat
      let &l:errorformat = self.config.errorformat
      cgetexpr self._result

      let args = split(self.config.arg, '|')
      execute 'Unite' join(args, ' ') 'qf'
    finally
      let &l:errorformat = errorformat
    endtry
  endfunction

  call quickrun#register_outputter('unite', l:outputter)
endfunction

if empty(quickrun#get_module('outputter', 'unite'))
  call s:register_unite_qf_outputter_module()
endif
" }}}
" simplenote.vim" {{{
"let g:SimplenoteUsername = ""
"let g:SimplenotePassword = ""
"source ~/.simplenoterc
" }}}
" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}
" VimShell {{{
nnoremap <Leader>vs :<C-u>VimShellPop<CR>

augroup MyVimShell
  autocmd!
  autocmd FileType vimshell nmap <buffer> q <Plug>(vimshell_hide)
augroup END

"
" Initialize execute file list.
let g:vimshell_execute_file_list = {}
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

" VimShell Prompt {{{
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

if has('win32') || has('win64') 
  let g:vimshell_prompt = $USERNAME."% "
else
  let g:vimshell_prompt = $USER."% "
endif
" }}}

let g:vimshell_enable_smart_case = 1

if !(has('win32') || has('win64'))
  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
  call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

autocmd FileType vimshell
      \ call vimshell#altercmd#define('g', 'git')
      \| call vimshell#altercmd#define('i', 'iexe')
      \| call vimshell#altercmd#define('l', 'll')
      \| call vimshell#altercmd#define('ll', 'ls -l')
      \| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

function! g:my_chpwd(args, context)
  call vimshell#execute('ls')
endfunction

autocmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
endfunction
" }}}
" Vimfiler {{{
nnoremap <silent> <Leader>vf :topleft VimFilerSplit<CR><Esc><C-W><S-H>
let g:vimfiler_as_default_explorer=1

augroup MyVimfiler
  autocmd!
  autocmd FileType vimfiler nmap <buffer> q <Plug>(vimfiler_exit)
augroup END
" }}}
" textmanip {{{
vmap <M-d> <Plug>(Textmanip.duplicate_selection_v)
vmap <C-h> <Plug>(Textmanip.move_selection_left)
nmap <M-d> <Plug>(Textmanip.duplicate_selection_n)
vmap <C-j> <Plug>(Textmanip.move_selection_down)
vmap <C-k> <Plug>(Textmanip.move_selection_up)
vmap <C-l> <Plug>(Textmanip.move_selection_right)
" }}}
" surround.vim {{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction",
      \'z':  "\"{{{ \r \"}}}"
      \ }
" }}}
" ref.vim {{{
" vsplitで開く
let g:ref_open = ':vsplit'
" filetype毎のソースを定義
let g:_detect_filetype = {
      \}
nnoremap <Leader>ra :<C-u>Ref alc 
nnoremap <Leader>rp :<C-u>Ref perldoc 
nnoremap <Leader>rm :<C-u>Ref man 
augroup MyRef
  autocmd!
  autocmd FileType ref nnoremap <buffer> q :<C-u>q<CR>
augroup END
" }}}
" ambicmd {{{
cnoremap <expr> <Space> ambicmd#expand("\<Space>")
cnoremap <expr> <CR>    ambicmd#expand("\<CR>")
" }}}
" submode {{{
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#leave_with('undo/redo', 'n', '', '<Esc>')
call submode#map('undo/redo', 'n', '', '-', 'g-')
call submode#map('undo/redo', 'n', '', '+', 'g+')

call submode#enter_with('tabnext', 'n', '', '<C-Tab>', ':<C-u>tabnext<CR>')
call submode#enter_with('tabnext', 'n', '', 'gt', ':<C-u>tabnext<CR>')
call submode#enter_with('tabnext', 'n', '', '<C-S-Tab>', ':<C-u>tabprevious<CR>')
call submode#enter_with('tabnext', 'n', '', 'gT', ':<C-u>tabprevious<CR>')
call submode#leave_with('tabnext', 'n', '', '<Esc>')
call submode#map('tabnext', 'n', '', '<Tab>', ':<C-u>tabnext<CR>')
call submode#map('tabnext', 'n', '', '<C-Tab>', ':<C-u>tabnext<CR>')
call submode#map('tabnext', 'n', '', 't', ':<C-u>tabnext<CR>')
call submode#map('tabnext', 'n', '', '<S-Tab>', ':<C-u>tabprevious<CR>')
call submode#map('tabnext', 'n', '', '<C-S-Tab>', ':<C-u>tabprevious<CR>')
call submode#map('tabnext', 'n', '', 'T', ':<C-u>tabprevious<CR>')
"
" function! s:resizeWindow()
"   call submode#enter_with('winsize', 'n', '', 'mws', '<Nop>')
"   call submode#leave_with('winsize', 'n', '', '<Esc>')
" 
"   let curwin = winnr()
"   wincmd j | let target1 = winnr() | exe curwin "wincmd w"
"   wincmd l | let target2 = winnr() | exe curwin "wincmd w"
" 
" 
"   execute printf("call submode#map ('winsize', 'n', 'r', 'j', '<C-w>%s')", curwin == target1 ? "-" : "+")
"   execute printf("call submode#map ('winsize', 'n', 'r', 'k', '<C-w>%s')", curwin == target1 ? "+" : "-")
"   execute printf("call submode#map ('winsize', 'n', 'r', 'h', '<C-w>%s')", curwin == target2 ? ">" : "<")
"   execute printf("call submode#map ('winsize', 'n', 'r', 'l', '<C-w>%s')", curwin == target2 ? "<" : ">")
" endfunction
" 
" nnoremap <C-w>r :<C-u>call <SID>resizeWindow()<CR>mws
" }}}
" restart.vim {{{
let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
command!
\   -bar
\   RestartWithSession
\   let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
\   | Restart
" }}}
" }}}
"-----------------------------------------------------------------------------
" GUI
"-----------------------------------------------------------------------------
" {{{
"+guiでコンパイルされている
if has('gui')
  "カラースキーム
  colorscheme robokai
endif

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
" }}}

" 現在のバッファのタグファイルを生成する{{{
" neocomplcache からタグファイルのパスを取得して、tags に追加する
nnoremap <expr><Space>tu g:TagsUpdate()
function! g:TagsUpdate()
  execute "setlocal tags=./tags,tags"
  let bufname = expand("%:p")
  if bufname!=""
    call system(
          \ "ctags ". 
          \ "-R --tag-relative=yes --sort=yes ".
          \ "--c++-kinds=+p --fields=+iaS --extra=+q "
          \ .bufname." `pwd`")
  endif
  for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
    execute "set tags+=".neocomplcache#cache#encode_name('include_tags', filename)
  endfor
  return ""
endfunction
"}}}

" tablineを設定{{{
" 各タブページのカレントバッファ名+αを表示
function! s:tabpage_label(n)
  " t:title と言う変数があったらそれを使う
  let title = gettabvar(a:n, 'title')
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

" vim:ts=2 st=2 sw=2
