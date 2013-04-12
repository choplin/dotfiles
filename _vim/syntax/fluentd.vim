if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

runtime! syntax/xml.vim

unlet b:current_syntax

syn match   fluentdComment   "#.*"

hi def link fluentdComment	 Comment

let b:current_syntax = "fluentd"
