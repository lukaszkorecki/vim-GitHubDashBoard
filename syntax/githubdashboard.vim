if version < 600
  syntax clear
elseif exists("b:current_syntax")
    finish
  endif

syn match   ghdUser   /@[a-zA-Z0-9]*/

syn keyword ghdVerb commented
syn keyword ghdVerb pulled
syn keyword ghdVerb pushed
syn keyword ghdVerb opened
syn keyword ghdVerb closed
syn keyword ghdVerb forked

" colors
if version >= 508 || !exists("did_conf_syntax_inits")
  if version < 508
    let did_todo_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ghdVerb Type

endif

let b:current_syntax = "githubdashboard"
