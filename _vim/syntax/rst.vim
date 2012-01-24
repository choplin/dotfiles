function! s:SynFgColor(hlgrp)
    return synIDattr(synIDtrans(hlID(a:hlgrp)), 'fg')
endfun

function! s:SynBgColor(hlgrp)
    return synIDattr(synIDtrans(hlID(a:hlgrp)), 'bg')
endfun

syn match rstEnumeratedList /^\s*[0-9#]\{1,3}\.\s/
syn match rstBulletedList /^\s*[+*-]\s/
syn match rstNbsp /[\xA0]/
"syn match rstEmDash /[\u2014]/
"syn match rstUnicode /[\u2013\u2018\u2019\u201C\u201D]/ " ? ‘ ’ “ ”

exec 'hi def rstBold    term=bold cterm=bold gui=bold guifg=' . s:SynFgColor('PreProc')
exec 'hi def rstItalic  term=italic cterm=italic gui=italic guifg=' . s:SynFgColor('Statement')
exec 'hi def rstNbsp    gui=underline guibg=' . s:SynBgColor('ErrorMsg')
"exec 'hi def rstEmDash  gui=bold guifg=' . s:SynFgColor('Title') . ' guibg='. s:SynBgColor('Folded')
"exec 'hi def rstUnicode guifg=' . s:SynFgColor('Number')
hi def rstList gui=undercurl guisp=Red

hi link rstEmphasis       rstItalic
hi link rstStrongEmphasis rstBold
hi link rstEnumeratedList Operator
hi link rstBulletedList   Operator

source $VIMRUNTIME/syntax/rst.vim

syn cluster rstCruft                contains=rstEmphasis,rstStrongEmphasis,
      \ rstInterpretedText,rstInlineLiteral,rstSubstitutionReference,
      \ rstInlineInternalTargets,rstFootnoteReference,rstHyperlinkReference,
      \ rstNbsp,rstEmDash,rstUnicode

" use another syntax inside sourcecode directive
let s:sourcecode_syntaxes = [
      \ ['vim', 'vim'],
      \ ['sh', '\(ba\)\?sh'],
      \ ['python', 'python'],
      \ ['haskell', 'haskell'],
      \ ['perl', 'perl'],
\ ]
let b:orig_current_syntax = b:current_syntax

for [s:syn_name, s:syn_pattern] in s:sourcecode_syntaxes
  unlet! b:current_syntax

  let s:source_name = 'rstSource' . substitute(s:syn_name, '^.', '\u&', '')
  let s:inc_name = s:syn_name . 'Syntax'

  execute 'syn include @' . s:inc_name . ' syntax/' . s:syn_name . '.vim'
  execute 'syn region ' . s:source_name . ' contained matchgroup=rstDirective'
      \ . ' start=/sourcecode::\s*' . s:syn_pattern . '/'
      \ . ' skip=/^$/'
      \ . ' end=/^\s\@!/ contains=@' . s:inc_name
  execute 'syn cluster rstDirectives add=' . s:source_name
endfor

let b:current_syntax = b:orig_current_syntax
unlet b:orig_current_syntax
