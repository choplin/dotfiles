"-----------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------
"{{{
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))

" Edit
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'kana/vim-operator-user'
Plug 'tyru/operator-camelize.vim'
Plug 'kana/vim-operator-replace'
Plug 'taku-o/vim-toggle'
Plug 'rhysd/clever-f.vim'
Plug 'vim-scripts/a.vim'
Plug 'editorconfig/editorconfig-vim'

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'

" Searching/Moving
Plug 'kana/vim-smartword'
Plug 'easymotion/vim-easymotion'
"Plug 'haya14busa/incsearch.vim'
"Plug 'haya14busa/incsearch-easymotion.vim'

" Utility
Plug 'kana/vim-submode'
Plug 'kana/vim-arpeggio'
Plug 'thinca/vim-ambicmd'
Plug 'jceb/vim-hier'
Plug 'kana/vim-tabpagecd'
Plug 'sudo.vim'
Plug 'airblade/vim-rooter'
Plug 'tyru/open-browser.vim', { 'on' : ['OpenBrowser', 'OpenBrowserSearch'] }
if v:version > 702
  Plug 'Shougo/vinarise'
endif
Plug 'rking/ag.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'frankier/neovim-colors-solarized-truecolor-only'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/grep.vim'
Plug 'Raimondi/delimitMate'
Plug 'neomake/neomake'
Plug 'thinca/vim-qfreplace'
Plug 'dkprice/vim-easygrep'
Plug 'rhysd/vim-grammarous'

"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" go
Plug 'fatih/vim-go'

" rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" scala
"Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins', 'for': 'scala' }
" Plug 'ensime/ensime-vim'

" cpp
" Plug 'critiqjo/lldb.nvim', { 'do': ':UpdateRemotePlugins' }

" snippet
Plug 'Shougo/neosnippet.vim'
Plug 'honza/vim-snippets'

" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

" denite
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nixprime/cpsm', { 'do': 'PY3=ON ./install.sh' }

" riot
Plug 'ryym/vim-riot'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

"Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

call plug#end()
filetype plugin indent on
"}}}
"-----------------------------------------------------------------------------
" Basic
"-----------------------------------------------------------------------------
" {{{
" Map leader to ,
let mapleader=','

"スワップを作らない
set noswapfile
set nobackup
set undodir=~/.local/share/nvim/undo
set undofile
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
"検索時に大文字を含んでいたら大/小を区別
set ignorecase
set smartcase
"Vimgrepで外部grepを使用
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ -iS
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
set completeopt=menuone,noinsert,noselect
" 行番号非表示
set nonumber
"
set backupcopy=yes
" normal mode/command line のみconceal表示をする
if has('conceal')
  set concealcursor=nc
endif

set fileformats=unix,dos,mac

" session management
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" change the cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" terminal
autocmd! BufEnter term://* startinsert
autocmd! TermOpen term://* call <SID>open_terminal()
function! s:open_terminal() abort
  tnoremap <buffer> <C-w>h     <C-\><C-n><C-w>h
  tnoremap <buffer> <C-w>j     <C-\><C-n><C-w>j
  tnoremap <buffer> <C-w>k     <C-\><C-n><C-w>k
  tnoremap <buffer> <C-w>l     <C-\><C-n><C-w>l
  startinsert
endfunction
nnoremap <M-t> :<C-u>vsplit +terminal<CR>

" open tig in terminal
command! Tig vsplit term://env\ VIM=''\ VIMRUNTIME=''\ tig

" python3
" Skip the check of neovim module
let g:python3_host_skip_check = 1

" reload externally edited file
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" source local vimrc
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif
" }}}
"-----------------------------------------------------------------------------
" Visual
"-----------------------------------------------------------------------------
" {{{
if !exists('g:not_finish_vimplug')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  set termguicolors
  set background=light
  colorscheme solarized8_light
endif

set mousemodel=popup
set guioptions=egmrti

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F
set titlestring=%F

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


nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

"<C-l>でハイライトを止める
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

nnoremap <C-W><C-F> <C-W><C-F><C-W><S-L>
inoremap jj <Esc>
noremap <C-[> <Esc>
"C-w tでタブ
nnoremap <C-W>t :<C-u>tabnew<CR>:cd<CR>
" help
" nnoremap <C-h> :<C-u>vertical help<Space>

" imap
inoremap <C-d> <ESC>lxi
inoremap <C-a>  <Home>
inoremap <C-e>  <End>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>

" cmap
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>

" quickfix/location list
nnoremap <silent> <expr><M->>
  \ len(getloclist(0)) == 1 ? ":\<C-u>ll 1\<CR>" :
  \ len(getloclist(0))      ? ":\<C-u>lnext\<CR>" :
  \ len(getqflist()) == 1  ? ":\<C-u>cc 1\<CR>" :
  \ ":\<C-u>cnext\<CR>"
nnoremap <silent> <expr><M-<>
  \ len(getloclist(0)) == 1 ? ":\<C-u>ll 1\<CR>" :
  \ len(getloclist(0))      ? ":\<C-u>lprevious\<CR>" :
  \ len(getqflist()) == 1  ? ":\<C-u>cc 1\<CR>" :
  \ ":\<C-u>cprevious\<CR>"

nnoremap <SID>[locationlist] <Nop>
nmap <Leader>l <SID>[locationlist]
nnoremap <silent> <SID>[locationlist]o :<C-u>lopen<CR>
nnoremap <silent> <SID>[locationlist]c :<C-u>lclose<CR>

nnoremap <SID>[quickfix] <Nop>
nmap <Leader>c <SID>[quickfix]
nnoremap <silent> <SID>[quickfix]o :<C-u>copen<CR>
nnoremap <silent> <SID>[quickfix]c :<C-u>cclose<CR>

function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - 2]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! s:copy_selected_text()
  let text = s:get_visual_selection()
  call system('reattach-to-user-namespace pbcopy', text)
endfunction

command! CopyToClipboard call s:copy_selected_text()
vnoremap <silent> <Leader>y :<C-u>CopyToClipboard<CR>

"}}}
"-----------------------------------------------------------------------------
" Plugin settings
"-----------------------------------------------------------------------------
" {{{
" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

if !exists('g:openbrowser_search_engines')
  let g:openbrowser_search_engines = {}
endif
let g:openbrowser_search_engines['amazon'] = 'http://www.amazon.co.jp/s/?keywords={query}'
" }}}
" submode {{{
if !exists('g:not_finish_vimplug')
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

  call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
  call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
  call submode#map('winsize', 'n', '', '>', '<C-w>>')
  call submode#map('winsize', 'n', '', '<', '<C-w><')
  call submode#map('winsize', 'n', '', '+', '<C-w>-')
  call submode#map('winsize', 'n', '', '-', '<C-w>+')
endif
" }}}
" operator-replace {{{
map _  <Plug>(operator-replace)
" }}}
" fugitive {{{
command! Gnow execute 'Git now'
" }}}
" ag {{{
nnoremap <SID>[ag] <Nop>
nmap <Leader>a <SID>[ag]
nnoremap <SID>[ag]g :<C-u>LAg<Space>
nnoremap <SID>[ag]w :<C-u>LAg<Space>
" }}}
" rooter {{{
" disable the default map (,cd)
map <Nop> <Plug>RooterChangeToRootDirectory
" }}}
" vim-go {{{
let g:go_snippet_engine = 'neosnippet'
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 0
augroup go
  autocmd!
  autocmd Filetype go
    \  command! -bang -buffer A call go#alternate#Switch(<bang>0, 'edit')
    \| command! -bang -buffer AV call go#alternate#Switch(<bang>0, 'vsplit')
    \| command! -bang -buffer AS call go#alternate#Switch(<bang>0, 'split')
augroup END
" }}}
" vim-racer {{{
let g:racer_cmd = "/Users/okuno/.cargo/bin/racer"
let $RUST_SRC_PATH="/Users/okuno/.ghq/github.com/rust-lang/rust/src"
" }}}
" deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" Undo inputted candidate
inoremap <expr><C-g>     deoplete#undo_completion()
" Refresh the candidates
inoremap <expr><C-l>     deoplete#refresh()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

imap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ deoplete#mappings#manual_complete()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

let g:deoplete#sources#clang#libclang_path = '/usr/local/opt/llvm/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/usr/local/opt/llvm/lib/clang'

if !exists('$GOPATH')
  let $GOPATH = expand('~/.go')
endif
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = expand('~/.cache/deoplete/go/').'$GOOS_$GOARCH'

" }}}
" neomake {{{
let g:neomake_go_enabled_makers = []
autocmd! BufWritePost * Neomake
autocmd! User NeomakeFinished HierUpdate
let s:metalinter_args = [
      \ '--skip',
      \ 'bindata',
      \ '--fast',
      \ '--vendor',
      \ '--tests',
      \ '--disable=gotype',
      \ '--disable=gocyclo',
      \ '--disable=dupl'
      \ ]

function! s:neomake_metalinter_args()
  let rootdir = FindRootDirectory()
  let target = ''
  if len(rootdir)
    let target = rootdir.'/...'
  else
    let target = expand('%:p:h')
  endif
  return s:metalinter_args + [target]
endfunction

let g:neomake_go_gometalinter_maker = {
  \ 'args': function('s:neomake_metalinter_args'),
  \ 'append_file': 0,
  \ 'errorformat':
    \ '%E%f:%l:%c:error: %m,' .
    \ '%E%f:%l::error: %m,' .
    \ '%W%f:%l:%c:warning: %m,' .
    \ '%W%f:%l::warning: %m'
  \ }

function! s:neomake_go_build_args()
  let fname = expand('%')
  let importPath = go#package#ImportPath(expand('%:p:h'))
  if fname =~ '_test\.go$'
    return ['test', '-o', '/dev/null', '-c', importPath]
  else
    return ['install', importPath]
  endif
endfunction

let g:neomake_go_go_maker = {
  \ 'args': function('s:neomake_go_build_args'),
  \ 'append_file': 0,
  \ 'errorformat': '%E%f:%l: %m'
  \ }
let g:neomake_go_enabled_makers = ['gometalinter', 'go']

" function! s:local_eslint() abort
"   let rootdir = FindRootDirectory()
"   let eslint = rootdir.'/node_modules/.bin/eslint'
"   if !executable(eslint)
"     return ''
"   endif
"   return eslint
" endfunction

" let g:neomake_javascript_eslint_maker = {
"   \ 'exe': function('s:local_eslint'),
"   \ 'args': ['-f', 'compact'],
"   \ 'errorformat':
"     \ '%E%f: line %l\, col %c\, Error - %m,' .
"     \ '%W%f: line %l\, col %c\, Warning - %m'
"   \ }

let g:neomake_javascript_eslint_maker = {
  \ 'exe': expand('%:p:h').'/node_modules/.bin/eslint',
  \ 'args': ['-f', 'compact'],
  \ 'errorformat':
    \ '%E%f: line %l\, col %c\, Error - %m,' .
    \ '%W%f: line %l\, col %c\, Warning - %m'
  \ }

let g:neomake_riot_eslint_maker = g:neomake_javascript_eslint_maker
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']

let g:neomake_riot_eslint_maker = g:neomake_javascript_eslint_maker
let g:neomake_riot_enabled_makers = ['eslint']
" }}}
" smartword {{{
nmap w   <Plug>(smartword-w)
nmap b   <Plug>(smartword-b)
nmap e   <Plug>(smartword-e)
" }}}
" vim-commentary {{{
vmap / <Plug>Commentary
" }}}
" neosnippet {{{
let g:neosnippet#disable_runtime_snippets = {'_' : 1}
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets,~/.config/nvim/snippets'
let g:neosnippet#scope_aliases = {}
let g:neosnippet#scope_aliases['riot'] = 'html,javascript'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" }}}
" hier {{{
execute "highlight hier_red     gui=bold,undercurl guifg=Red"
execute "highlight hier_orange  gui=bold,undercurl guifg=Orange"
execute "highlight hier_green   gui=bold,undercurl guifg=Green"

let g:hier_highlight_group_qf = "hier_red"
let g:hier_highlight_group_qfw = "hier_orange"
let g:hier_highlight_group_qfi = "hier_green"

let g:hier_highlight_group_loc = "hier_red"
let g:hier_highlight_group_locw = "hier_orange"
let g:hier_highlight_group_loci = "hier_green"
" }}}
" easygrep {{{
" disable default mappings
let g:EasyGrepMappingsSet = 1
let g:EasyGrepCommand = 1
" }}}
" NERDTree {{{
nnoremap <SID>[nerdtree] <Nop>
nmap <Leader>n <SID>[nerdtree]
nnoremap <silent> <SID>[nerdtree]t :<C-u>NERDTreeToggle<CR>
nnoremap <silent> <SID>[nerdtree]f :<C-u>NERDTreeFind<CR>
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ' '


" }}}
" airline {{{
let g:airline_theme = 'powerlineish'
let g:airline_extensions = [
  \ 'branch',
  \ 'tabline',
  \ 'quickfix',
  \ 'hunks',
  \ 'neomake',
  \ ]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline_powerline_fonts = 1
" }}}
" ensime {{{
autocmd! BufWritePost *.scala silent :EnTypeCheck
autocmd! FileType scala call <SID>filetype_scala()

function! s:filetype_scala() abort
  nnoremap <buffer> <silent> <C-]>  :<C-u>EnDeclaration<CR>
  nnoremap <buffer> <silent> <C-w>] :<C-u>EnDeclarationSplit<CR>
  nnoremap <buffer> <silent> <C-w><C-]> :<C-u>EnDeclarationSplit<CR>
  nnoremap <buffer> <silent> <C-v>] :<C-u>EnDeclarationSplit v<CR>

  nnoremap <buffer> <silent> K :<C-u>EnDocBrowse<CR>

  nnoremap <SID>[ensime] <Nop>
  nmap <Leader>e <SID>[ensime]
  nnoremap <buffer> <silent> <SID>[ensime]t :<C-u>EnType<CR>
  nnoremap <buffer> <silent> <SID>[ensime]T :<C-u>EnTypeCheck<CR>
  nnoremap <buffer> <silent> <SID>[ensime]i :<C-u>EnInspectType<CR>
  nnoremap <buffer> <silent> <SID>[ensime]I :<C-u>EnSuggestImport<CR>
  nnoremap <buffer> <silent> <SID>[ensime]r :<C-u>EnRename<CR>

  " open sbt in terminal
  command! -buffer Sbt vsplit term://sbt
endfunction

" if !exists('g:deoplete#omni#input_patterns')
"   let g:deoplete#omni#input_patterns = {}
" endif
" let g:deoplete#omni#input_patterns.scala = [
"   \ '[^. *\t]\.\w*',
"   \ '[:\[,] ?\w*',
"   \ '^import .*'
"   \]
" }}}
" denite {{{
nnoremap <C-p> :<C-u>Denite file_rec<CR>

call denite#initialize()
" Change file_rec command.
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" Change mappings.
call denite#custom#map('_', "\<C-n>", 'move_to_next_line')
call denite#custom#map('_', "\<C-p>", 'move_to_prev_line')

" Change matchers.
call denite#custom#source(
\ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
" call denite#custom#source(
" \ 'file_rec', 'matchers', ['matcher_cpsm'])

" Add custom menus
let s:menus = {}

let s:menus.zsh = {
  \ 'description': 'Edit your import zsh configuration'
  \ }
let s:menus.zsh.file_candidates = [
  \ ['zshrc', '~/.config/zsh/.zshrc'],
  \ ['zshenv', '~/.zshenv'],
  \ ]

call denite#custom#var('menu', 'menus', s:menus)

call denite#custom#source('file_mru', 'converters',
      \ ['converter_relative_word'])
" }}}
" editorconfig {{{
let g:EditorConfig_core_mode = 'python_external'
" }}}
" lightline {{{
let s:winwidth_threshold = 70

function! s:special_buffer()
  return expand('%:t') =~? 'NERD' || &ft =~? 'deoplete'
endfunction

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitgutter', 'fugitive', 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'lineinfo': "\ue0a1 %3l:%-2v",
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'gitgutter': 'LightlineGitGutter',
      \   'filetype': 'LightlineFiletype',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'component_expand': {
      \   'lineinfo': 'LightlineLineInfo',
      \   'percent': 'LightlinePercent',
      \   'neomake': 'NeomakeStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'neomake': 'error',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ 'tabline_separator': { 'left': '', 'right':  ''},
      \ 'tabline_subseparator': { 'left': '|', 'right':  '|'},
      \ }

function! LightlineLineInfo()
  return winwidth(0) > s:winwidth_threshold ? "\ue0a1 %3l:%-2v" : ''
endfunction

function! LightlinePercent()
  return winwidth(0) > s:winwidth_threshold ? '%3p%%' : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERD' :
        \ &ft == 'denite' ? denite#get_status_mode() :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  let path = expand('%')
  return fname =~ 'NERD_tree' ? '' :
        \ &ft == 'denite' ? denite#() :
        \ (&readonly ? "\ue0a2 " : '') .
        \ ('' == fname ? '[No Name]' : FindRootDirectory() ? path : fname) .
        \ (&ft =~ 'help' ? '' : &modified ? ' +' : &modifiable ? '' : ' -')
endfunction

function! LightlineFugitive()
  if !s:special_buffer() && exists('*fugitive#head')
    let mark = "\ue0a0 "
    let branch = fugitive#head()
    return branch !=# '' ? mark.branch : ''
  endif
  return ''
endfunction

function! LightlineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= s:winwidth_threshold
    return ''
  endif
  let symbols = ['+','~','-']
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction


function! LightlineFileformat()
  return winwidth(0) > s:winwidth_threshold ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > s:winwidth_threshold ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > s:winwidth_threshold ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction
" }}}
" incsearch {{{
" function! s:incsearch_config(...) abort
"   return incsearch#util#deepextend(deepcopy({
"   \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"   \   'keymap': {
"   \     "\<CR>": '<Over>(easymotion)'
"   \   },
"   \   'is_expr': 0
"   \ }), get(a:, 1, {}))
" endfunction
" 
" noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
" noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
" noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))
" 
" map z/ <Plug>(incsearch-easymotion-/)
" map z? <Plug>(incsearch-easymotion-?)
" map zg/ <Plug>(incsearch-easymotion-stay)<Paste>
" }}}
" }}}
" vim:ts=2 sw=2