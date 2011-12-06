let s:context = unite#get_context()
if s:context.buffer_name ==# 'completion'
  inoremap <buffer> <expr> <C-y> unite#do_action('insert')
  inoremap <buffer> <expr> <C-a> unite#do_action('async')
  inoremap <buffer> <expr> <C-g> unite#do_action('grep_directory')
endif
