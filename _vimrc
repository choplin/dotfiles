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
"-----------------------------------------------------------------------------
" Plugins
"-----------------------------------------------------------------------------
" {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

if v:version > 702
  let s:enable_unite = 1
else
  let s:enable_unite = 0
endif

" Edit {{{
  " マルチバイト対応の整形
  Plug 'h1mesuke/vim-alignta'
  " surround.vim : テキストを括弧で囲む／削除する
  Plug 'tpope/vim-surround'
  " vim-operator-user : 簡単にoperatorを定義できるようにする
  Plug 'kana/vim-operator-user'
  " operator-camelize : camel-caseへの変換
  Plug 'tyru/operator-camelize.vim'
  " operator-replace : yankしたものでreplaceする
  Plug 'kana/vim-operator-replace'
  " textobj-user : 簡単にVimエディタのテキストオブジェクトをつくれる
  Plug 'kana/vim-textobj-user'
  " <C-a>でtrue/false切替。他色々
  Plug 'taku-o/vim-toggle'
  " f/Fの移動をリッチに
  Plug 'rhysd/clever-f.vim'
" }}}

" Completion {{{
  " completion
  if has('lua')
    Plug 'Shougo/neocomplete'
  else
    Plug 'Shougo/neocomplcache'
  end
  " clang補完
  Plug 'justmao945/vim-clang', { 'for' : ['c', 'cpp'] }
  " snippet
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
" }}}

" Searching/Moving{{{
  " vim-smartword : 単語移動がスマートな感じで
  Plug 'kana/vim-smartword'
  " <Leader><Leader>w/fなどで、motion先をhilightする
  Plug 'Lokaltog/vim-easymotion', {'vim_version' : '7.3'}
" }}}

" Programming {{{
  " quickrun.vim : 編集中のファイルを簡単に実行できるプラグイン
  Plug 'thinca/vim-quickrun'
  Plug 'mattn/quickrunex-vim'
" }}}

" FileType {{{
" " vim
  Plug 'thinca/vim-ft-vim_fold'
  " markdown
  Plug 'tpope/vim-markdown'
  " scala
  Plug 'derekwyatt/vim-scala'
  " haskell
  Plug 'kana/vim-filetype-haskell'
  " reStructuredText
  Plug 'nvie/vim-rst-tables'
  " yaml
  Plug 'chase/vim-ansible-yaml'
  " jinja2
  Plug 'mitsuhiko/vim-jinja'
  " Dockerfile
  Plug 'ekalinin/Dockerfile.vim'
  " go
  Plug 'fatih/vim-go'
  " rust
  Plug 'rust-lang/rust.vim'
  Plug 'racer-rust/vim-racer'
  " cpp
  Plug 'vim-jp/cpp-vim', { 'for' : ['cpp'] }
  Plug 'osyo-manga/vim-stargate', { 'for' : ['cpp'] }
  " python
  Plug 'jmcantrell/vim-virtualenv'
  " thrift
  Plug 'solarnz/thrift.vim'
  " TOML
  Plug 'cespare/vim-toml'
" }}}

" Buffer {{{
  " ファイラー
  if s:enable_unite
    Plug 'Shougo/vimfiler'
  endif
  " .c/cpp .hを切り替え
  Plug 'vim-scripts/a.vim'
  " gfを拡張
  Plug 'kana/vim-gf-user'
  " gf for git diff
  Plug 'kana/vim-gf-diff'
" }}}

" Utility {{{
  " vimproc : vimから非同期実行。vimshellで必要
  Plug 'Shougo/vimproc', { 'do': 'make'}
  " 任意のsub modeを利用できるようにする
  Plug 'kana/vim-submode'
  " キーの同時押しにmapできるようにする
  Plug 'kana/vim-arpeggio'
  " .local.vimrcを読み込む
  Plug 'thinca/vim-localrc'
  " vimの二重起動を防ぐ
  Plug 'thinca/vim-singleton'
  " vimのデータを見やすく出力
  Plug 'thinca/vim-prettyprint'
  " Exコマンドをそれっぽく展開
  Plug 'thinca/vim-ambicmd'
  " エラーの箇所の表示
  Plug 'jceb/vim-hier'
  " tab local cd
  Plug 'kana/vim-tabpagecd'
  " sudo
  Plug 'vim-scripts/sudo.vim'
  " リポジトリのrootに移動
  Plug 'airblade/vim-rooter'
" }}}

" Tool {{{
  " vimの再起動を行う
  Plug 'tyru/restart.vim'
  " open-browser.vim : カーソルの下のURLを開くor単語を検索エンジンで検索
  Plug 'tyru/open-browser.vim', { 'on' : ['OpenBrowser', 'OpenBrowserSearch'] }
  " vinarise
  if v:version > 702
    Plug 'Shougo/vinarise'
  endif
  " fugitive
  Plug 'tpope/vim-fugitive'
  " github
  Plug 'tyru/open-browser-github.vim', { 'on' : ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'] }
  " ag
  Plug 'rking/ag.vim'
  " EditorConfig
  Plug 'editorconfig/editorconfig-vim'
" }}}

" ColorScheme{{{
  Plug 'altercation/vim-colors-solarized'
" }}}

" Unite {{{
  if s:enable_unite
    " 本体
    Plug 'Shougo/unite.vim'
    " QuickFix
    Plug 'osyo-manga/unite-quickfix'
    " other
    Plug 'sorah/unite-ghq'
  endif
" }}}
"
call plug#end()
" }}}
"-----------------------------------------------------------------------------
" Plugin settings
"-----------------------------------------------------------------------------
" {{{
" matchit {{{
source $VIMRUNTIME/macros/matchit.vim
" }}}
" neosnippets {{{
if has("win32") || has("win64")
  let g:neosnippet#snippets_directory =  '~/vimfiles/snippets'
else
  let g:neosnippet#snippets_directory =  '~/.vim/snippets'
endif

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
imap <C-s>     <Plug>(neosnippet_start_unite_snippet)
xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" }}}
" unite.vim {{{
if s:enable_unite
  " 入力モードで開始する
  let g:unite_enable_start_insert=1
  " 下に開く
  let g:unite_split_rule = 'botright'
  " history/yankを有効化
  let g:unite_source_history_yank_enable = 1

  let g:unite_source_grep_default_opts = '-Hn --color=never'

  let g:unite_source_rec_max_cache_files = 20000

  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
  elseif executable('ack-grep')
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
    let g:unite_source_grep_recursive_opt = ''
  endif

  nnoremap <SID>[unite] <Nop>
  nnoremap <SID>[unite_project] <Nop>
  nmap <Leader>u <SID>[unite]
  nmap <Leader>p <SID>[unite_project]
  nnoremap <silent> <SID>[unite]b :<C-u>Unite buffer<CR>
  nnoremap <silent> <SID>[unite]u :<C-u>Unite bookmark buffer file_mru<CR>
  nnoremap <silent> <SID>[unite]a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
  nnoremap <silent> <SID>[unite]g :<C-u>Unite ghq<CR>
  nnoremap <silent> <SID>[unite]s :<C-u>Unite source<CR>
  nnoremap <silent> <SID>[unite_project]r :<C-u>call <SID>unite_project('file_rec/git')<CR>
  nnoremap <silent> <SID>[unite_project]g :<C-u>call <SID>unite_project('grep')<CR>
  nnoremap <SID>[unite_project]d :<C-u>lcd <C-r>=unite#util#path2project_directory(expand('%'))<CR><CR>

  "nnoremap <silent> <C-h> :<C-u>Unite help<CR>

  function! s:unite_project(source, ...)
    let dir = unite#util#path2project_directory(expand('%'))
    execute 'Unite' a:source . ':' . escape(dir, ':') . (a:0 > 0 ? ':' . join(a:000, ':') : '')
  endfunction

  call unite#custom#default_action('directory', 'vimfiler')
  call unite#custom#default_action('source/ghq/directory', 'vimfiler')

  " タグジャンプをunite-tagsで置き換え
  " autocmd BufEnter *
  " \   if empty(&buftype)
  " \|      nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
  " \|  endif

  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()"{{{
    " Overwrite settings.

    nmap <buffer> <ESC>      <Plug>(unite_exit)
    imap <buffer> jj      <Plug>(unite_insert_leave)

    " <C-l>: manual neocomplcache completion.
    inoremap <buffer> <C-l>  <C-x><C-u><C-p><Down>
  endfunction"}}}
endif
" }}}
" quickrun {{{
noremap <SID>[quickrun] <Nop>
map <Leader>q <SID>[quickrun]
nmap  <SID>[quickrun]r <Plug>(quickrun)

let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 50,
\       "outputter" : "error",
\       "outputter/error/success" : "buffer",
\       "outputter/error/error" : "quickfix",
\       "outputter/buffer/split" : ":botright 8sp",
\       "outputter/buffer/name" : "QuickRun output",
\       "outputter/buffer/running" : "running",
\       "outputter/buffer/close_on_empty" :1,
\   },
\   "cpp" : {
\       "type" : "cpp/clang++",
\       "cmdopt" : "-std=c++11",
\   },
\}

" :QuickRun 時に quickfix の中身をクリアする
" こうしておかないと quickfix の中身が残ったままになってしまうため
let s:hook = {
\   "name" : "clear_quickfix",
\   "kind" : "hook",
\}

function! s:hook.on_normalized(session, context)
    call setqflist([])
endfunction

call quickrun#module#register(s:hook, 1)
unlet s:hook
" }}}
" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

if !exists('g:openbrowser_search_engines')
  let g:openbrowser_search_engines = {}
endif
let g:openbrowser_search_engines['amazon'] = 'http://www.amazon.co.jp/s/?keywords={query}'
" }}}
" Vimfiler {{{
if s:enable_unite
  "nnoremap <silent> <Leader>vf :VimFilerBufferDir -simple -split -winwidth=50<CR>
  nnoremap <silent> <Leader>vb :VimFilerBufferDir<CR>
  nnoremap <silent> <Leader>vf :VimFiler<CR>
  let g:vimfiler_as_default_explorer=1

  " Like Textmate icons.
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'

  " ignore
  let s:ignore_target = {
        \ 'dotfiles' : '\..\+',
        \ 'obj' : '.\+\.o'
        \ }
  let g:vimfiler_ignore_pattern = '^\%('.join(values(s:ignore_target), '\|').'\)$'

  augroup MyVimfiler
    autocmd!
    autocmd FileType vimfiler nmap <buffer> q <Plug>(vimfiler_exit)
  augroup END
endif
" }}}
" surround.vim {{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction",
      \'z':  "\"{{{ \r \"}}}"
      \ }
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
" operator-replace {{{
map _  <Plug>(operator-replace)
" }}}
" operator-camelize {{{
nmap <Leader>C  <Plug>(operator-camelize-toggle)
vmap <Leader>C  <Plug>(operator-camelize-toggle)
" }}}
" Gtags{{{
nnoremap <SID>[gtags] <Nop>
nmap <Leader>g <SID>[gtags]
" 定義箇所
nnoremap <silent> <C-g> :<C-u>Gtags <C-r><C-w><CR>
" 使用箇所
nnoremap <silent> <SID>[gtags]r :<C-u>Gtags -r <C-r><C-w><CR>
" シンボル
nnoremap <silent> <SID>[gtags]s :<C-u>Gtags -s <C-r><C-w><CR>
" grep
nnoremap <silent> <SID>[gtags]g :<C-u>Gtags -g <C-r><C-w><CR>
" 関数一覧
nnoremap <silent> <SID>[gtags]l :<C-u>Gtags -f %<CR>
" update
nnoremap <expr> <SID>[gtags]u GtagsUpdate()

" from http://d.hatena.ne.jp/abulia/20111205/1323111263
function! GtagsUpdate()
  let gtagsroot = s:GtagsCscope_GtagsRoot()
  if gtagsroot == ''
    silent! exe "!gtags"
    echo "update gtags at current directory"
  else
    let l:now_pwd = getcwd()
    echo "update gtags at " . gtagsroot
    silent! exe "cd " . gtagsroot
    silent! exe "!gtags"
    silent! exe "cd " . l:now_pwd
  endif
  silent! exec "redr!"
endfunction

" from gtags-cscope.vim
function! s:GtagsCscope_GtagsRoot()
    let cmd = "global -pq"
    let cmd_output = system(cmd)
    if v:shell_error != 0
        if v:shell_error == 3
            call s:Error('GTAGS not found.')
        else
            call s:Error('global command failed. command line: ' . cmd)
        endif
        return ''
    endif
    return strpart(cmd_output, 0, strlen(cmd_output) - 1)
endfunction
" }}}
" neocomplcache && neocomplete {{{
if has('lua')
  " neocomplete {{{
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

  " For cursor moving in insert mode(Not recommended)
  "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
  " Or set this.
  "let g:neocomplete#enable_cursor_hold_i = 1
  " Or set this.
  "let g:neocomplete#enable_insert_char_pre = 1

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


  highlight Pmenu ctermbg=8 guibg=#606060
  highlight PmenuSel ctermbg=1 guifg=#dddd00 guibg=#1f82cd
  highlight PmenuSbar ctermbg=0 guibg=#d6d6d6

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#force_omni_input_patterns.c =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
  let g:neocomplete#force_omni_input_patterns.cpp =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  " }}}
else
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

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist'
        \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplcache#undo_completion()
  inoremap <expr><C-l>     neocomplcache#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

  " rsense
  let g:rsenseUseOmniFunc = 1
  if filereadable(expand('~/.vim/bundle/rsense/bin/rsense'))
    let g:rsenseHome = expand('~/.vim/bundle/rsense')
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  endif

  " for clang_complete
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_overwrite_completefunc = 1
  " }}}
endif
" }}}
" fugitive {{{
command! Gpull Git pull
command! Gpush Git push
command! Gammend execute 'Git commit --amend --no-edit'
command! Gnow execute 'Git now'
" }}}
" ag {{{
nnoremap <SID>[ag] <Nop>
nmap <Leader>ag <SID>[ag]
nnoremap <SID>[ag] :<C-u>Ag 
nnoremap <silent> <C-a> :<C-u>Ag <C-r><C-w><CR>
" }}}
" rooter {{{
" disable the default map (,cd)
map <Nop> <Plug>RooterChangeToRootDirectory
" }}}
" vim-go {{{
let g:gocomplete#system_function = 'vimproc#system2' "to use vimproc
let g:go_snippet_engine = 'neosnippet'
let g:go_fmt_command = "goimports"
" }}}
" vim-racer {{{
let g:racer_cmd = "/Users/okuno/.multirust/toolchains/stable/cargo/bin/racer"
let $RUST_SRC_PATH="/Users/okuno/.ghq/github.com/rust-lang/rust/src"
" }}}
" vim-clang {{{
" disable auto completion for vim-clang
let g:clang_auto = 0
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_use_library = 1

" default 'longest' can not work with neocomplete
let g:clang_c_completeopt   = 'menuone'
let g:clang_cpp_completeopt = 'menuone'

if executable('clang-3.6')
    let g:clang_exec = 'clang-3.6'
elseif executable('clang-3.5')
    let g:clang_exec = 'clang-3.5'
elseif executable('clang-3.4')
    let g:clang_exec = 'clang-3.4'
else
    let g:clang_exec = 'clang'
endif

if executable('clang-format-3.6')
    let g:clang_format_exec = 'clang-format-3.6'
elseif executable('clang-format-3.5')
    let g:clang_format_exec = 'clang-format-3.5'
elseif executable('clang-format-3.4')
    let g:clang_format_exec = 'clang-format-3.4'
else
    let g:clang_format_exec = 'clang-format'
endif

let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
" }}}
" }}}
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
if has('conceal')
  set concealcursor=nc
endif

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


nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

"<C-l>でハイライトを止める
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

nnoremap <C-W><C-F> <C-W><C-F><C-W><S-L>

" jjでESC
inoremap jj <Esc>
" help
nnoremap <C-h> :<C-u>vertical help 
"C-w tでタブ
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

" ft-vim_fold {{{
augroup foldmethod-expr
  autocmd!
  autocmd InsertEnter * if &l:foldmethod ==# 'expr'
  \                   |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
  \                   |   setlocal foldmethod=manual foldexpr=0
  \                   | endif
  autocmd InsertLeave * if exists('b:foldinfo')
  \                   |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
  \                   | endif
augroup END
" }}}

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
" }}}
"-----------------------------------------------------------------------------
" Command
"-----------------------------------------------------------------------------
" {{{
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
" vim:ts=2 sw=2
