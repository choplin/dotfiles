setlocal makeprg=sbt-no-color\ compile
if exists("current_compiler")
  finish
endif
let current_compiler = "sbt"

setlocal errorformat=%E[error]\ %f:%l:\ %m,%C[error]\ %p^,%-C%.%#,%Z,
               \%W[warn]\ %f:%l:\ %m,%C[warn]\ %p^,%-C%.%#,%Z,
               \%-G%.%#
setlocal errorfile=target/error
