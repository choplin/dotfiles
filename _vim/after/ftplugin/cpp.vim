let s:BOOST_ROOT = '/usr/local/include'
let &path = &path.','.s:BOOST_ROOT

" libclang を使用して高速に補完を行う
let g:neocomplcache_clang_use_library=1
" clang.dll へのディレクトリパス
let g:neocomplcache_clang_library_path='/Developer/usr/clang-ide/lib'
" clang のコマンドオプション
" MinGW や Boost のパス周りの設定は手元の環境に合わせて下さい
let g:neocomplcache_clang_user_options =
    \ '-I /usr/local/include '
" neocomplcache で表示される補完の数を増やす
" これが少ないと候補が表示されない場合があります
let g:neocomplcache_max_list=1000

nnoremap <buffer> K :<C-u>GtagsCursor<CR>:Unite qf<CR>
