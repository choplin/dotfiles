let g:ghcmod_hlint_options = ['--ignore=Redundant $']

nnoremap <buffer> <SID>[ghcmod] <Nop>
nmap <buffer> <Leader>h <SID>[ghcmod]
nnoremap <buffer> <silent> <SID>[ghcmod]t :<C-u>GhcModType<CR>
nnoremap <buffer> <silent> <SID>[ghcmod]l :<C-u>GhcModTypeClear<CR>
nnoremap <buffer> <silent> <SID>[ghcmod]c :<C-u>GhcModCheckAndLintAsync<CR>
nnoremap <buffer> <silent> <SID>[ghcmod]e :<C-u>GhcModExpand<CR>
nnoremap <buffer> <silent> <SID>[ghcmod]h :<C-u>call <SID>unite_hoogle_type()<CR>
nnoremap <buffer> <silent> <SID>[ghcmod]y :<C-u>call <SID>paste_type_signature()<CR>

function! s:unite_hoogle_type()
  try
    let [_, l:type] = ghcmod#type()
  catch
    return
  endtry
  call ghcmod#type_clear()
  call unite#start(['hoogle'], { 'input': l:type })
endfunction

function! s:paste_type_signature()
  try
    let signature = expand('<cword>').' :: '.ghcmod#type()[1]
  catch
    return
  endtry
  call ghcmod#type_clear()
  silent .-1 put =signature
endfunction
