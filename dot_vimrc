"-----------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------
"{{{
if has('win32') || has('win64')
    let s:vimdir=expand('~/vimfiles')
else
    let s:vimdir=expand('~/.vim')
endif

let s:vimplug_exists=s:vimdir.'/autoload/plug.vim'

if !filereadable(s:vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  execute '!curl -fLo '.s:vimplug_exists.' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let g:not_finish_vimplug = "yes"
  PlugInstall
endif

call plug#begin(s:vimdir.'/plugged')
  " quoting/parenthesizing made simple
  Plug 'tpope/vim-surround'
  " Extended f, F, t and T key mappings for Vim
  Plug 'rhysd/clever-f.vim'
  " Vim motions on speed!
  Plug 'easymotion/vim-easymotion'
  " Alternate Files quickly
  Plug 'vim-scripts/a.vim'
  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  " EditorConfig
  Plug 'editorconfig/editorconfig-vim'
  " solarized
  Plug 'lifepillar/vim-solarized8'
  " onedark
  Plug 'joshdick/onedark.vim'
  " A simple, easy-to-use Vim alignment plugin.
  Plug 'junegunn/vim-easy-align'
  " Snippet
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  " A tree explorer plugin for vim.
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  " Adds file type glyphs/icons to popular Vim plugins
  Plug 'ryanoasis/vim-devicons'
  " Completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " fzf
  Plug '/home/linuxbrew/.linuxbrew/opt/fzf'
  Plug 'junegunn/fzf.vim'
  " comment stuff out
  Plug 'tpope/vim-commentary'
  " Syntax Check
  Plug 'w0rp/ale'
  " A light and configurable statusline/tabline plugin for Vim
  Plug 'itchyny/lightline.vim'
  " Changes Vim working directory to project root
  Plug 'airblade/vim-rooter'
  " A solid language pack for Vim.
  Plug 'sheerun/vim-polyglot'
  " filetype:vim
  Plug 'thinca/vim-ft-vim_fold'
  " filetype:go
  Plug 'fatih/vim-go'
call plug#end()
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
let &undodir=s:vimdir.'/undo'
set undofile
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"タブの代わりに空白文字を挿入する
set expandtab
"シフト移動幅
set shiftwidth=4
"ファイル内の Tab が対応する空白の数
set tabstop=4
"タブ文字、行末など不可視文字を表示する
set list
"listで表示される文字のフォーマットを指定する
set listchars=tab:▸\ ,extends:<,trail:_
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
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
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
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

set backupcopy=yes
" normal mode/command line のみconceal表示をする
if has('conceal')
  set concealcursor=nc
endif

set fileformats=unix,dos,mac

" session management
let g:session_directory = s:vimdir.'/session'
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" terminal
" autocmd! BufEnter term://* startinsert
" autocmd! TermOpen term://* call <SID>open_terminal()
" function! s:open_terminal() abort
"   tnoremap <buffer> <C-w>h     <C-\><C-n><C-w>h
"   tnoremap <buffer> <C-w>j     <C-\><C-n><C-w>j
"   tnoremap <buffer> <C-w>k     <C-\><C-n><C-w>k
"   tnoremap <buffer> <C-w>l     <C-\><C-n><C-w>l
"   startinsert
" endfunction
" nnoremap <M-t> :<C-u>vsplit +terminal<CR>

" open tig in terminal
" command! Tig vsplit term://env\ VIM=''\ VIMRUNTIME=''\ tig
command! Tig vsplit term://tig

" python3
" Skip the check of neovim module
let g:python3_host_skip_check = 1

" reload externally edited file
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" source local vimrc
if filereadable(s:vimdir.'/local.vim')
  execute 'source '.s:vimdir.'/local.vim'
endif
" }}}
"-----------------------------------------------------------------------------
" Visual
"-----------------------------------------------------------------------------
" {{{
if !exists('g:not_finish_vimplug')
  set termguicolors
  set background=light
  "colorscheme solarized8
  colorscheme onedark
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

nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

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
  let @+ = s:get_visual_selection()
endfunction

command! CopyToClipboard call s:copy_selected_text()
vnoremap <silent> <Leader>y :<C-u>CopyToClipboard<CR>

"}}}
"-----------------------------------------------------------------------------
" Plugin settings
"-----------------------------------------------------------------------------
" {{{
" fugitive {{{
command! Gnow execute 'Git now'
" }}}
" rooter {{{
" disable the default map (,cd)
map <Nop> <Plug>RooterChangeToRootDirectory
" }}}
" vim-go {{{
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_snippet_engine = 'neosnippet'
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 0
let g:go_addtags_transform = "snakecase"
augroup go
  autocmd!
  autocmd Filetype go
    \  command! -bang -buffer A call go#alternate#Switch(<bang>0, 'edit')
    \| command! -bang -buffer AV call go#alternate#Switch(<bang>0, 'vsplit')
    \| command! -bang -buffer AS call go#alternate#Switch(<bang>0, 'split')
augroup END
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 0
let g:go_addtags_transform = "snakecase"

augroup MyGoAutocmd
    autocmd!
    au FileType go nmap K <Plug>(go-doc)
    au FileType go nmap <leader>gi <Plug>(go-info)
augroup END
" }}}
" vim-commentary {{{
vmap / <Plug>Commentary
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
" NERDTree {{{
nnoremap <SID>[nerdtree] <Nop>
nmap <Leader>n <SID>[nerdtree]
nnoremap <silent> <SID>[nerdtree]t :<C-u>NERDTreeToggle<CR>
nnoremap <silent> <SID>[nerdtree]f :<C-u>NERDTreeFind<CR>
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ''
let g:webdevicons_enable_denite = 0
" }}}
" editorconfig {{{
" }}}
" lightline {{{
let s:winwidth_threshold = 70

function! s:special_buffer()
  return expand('%:t') =~? 'NERD' || &ft =~? 'deoplete'
endfunction

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitgutter', 'fugitive', 'filename' ], ['ale_ok', 'ale_warning', 'ale_error'] ],
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
      \   'ale_error': 'LightLineAleError',
      \   'ale_warning': 'LightLineAleWarning',
      \   'ale_ok': 'LightLineAleOk',
      \ },
      \ 'component_type': {
      \   'neomake': 'error',
      \   'ale_error': 'error',
      \   'ale_warning': 'warning',
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


function! LightLineAleError() abort
  return s:ale_string(0)
endfunction

function! LightLineAleWarning() abort
  return s:ale_string(1)
endfunction

function! LightLineAleOk() abort
  return s:ale_string(2)
endfunction

function! s:ale_string(mode)
  if !exists('g:ale_buffer_info')
    return ''
  endif

  let l:buffer = bufnr('%')
  let l:counts = ale#statusline#Count(l:buffer)
  let [l:error_format, l:warning_format, l:no_errors] = g:ale_statusline_format

  if a:mode == 0 " Error
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors ? printf(l:error_format, l:errors) : ''
  elseif a:mode == 1 " Warning
    let l:warnings = l:counts.warning + l:counts.style_warning
    return l:warnings ? printf(l:warning_format, l:warnings) : ''
  endif

  return l:counts.total == 0? l:no_errors: ''
endfunction
" }}}
" ale {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

let g:ale_linters = {
      \ 'go': ['gometalinter'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['tslint'],
      \}
let g:ale_go_gometalinter_options = '--fast --enable=megacheck'

let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

augroup MyALEAutocmd
    autocmd!
    autocmd User ALELint HierUpdate
    autocmd User ALELint call lightline#update()
augroup END
" }}}
" rust {{{
let g:rustfmt_autosave = 1
let g:racer_cmd = "/Users/okuno/.cargo/bin/racer"
augroup MyRustAutocmd
    autocmd!
    au FileType rust nmap <C-]> <Plug>(rust-def)
    au FileType rust nmap K <Plug>(rust-doc)
augroup END
" }}}
" fzf {{{
nnoremap <silent> <C-P> :<C-u>Commands<CR>
nnoremap <silent> <C-p> :<C-u>Files<CR>
" }}}
" commentary {{{
vnoremap / :<C-u>Commetary<CR>
" }}}
" }}}
" vim:ts=2 sw=2
