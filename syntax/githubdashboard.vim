if version < 600
  syntax clear
elseif exists("b:current_syntax")
    finish
  endif

syn match   ghdUser   /@[a-zA-Z0-9]*/
syn match ghdURL /https:\/\/[a-zA-Z0-9\,\?\&\-\.\/_]*/

syn match ghdIssueNumber /#[\d]*/

syn keyword ghdVerb commented
syn keyword ghdVerb pulled
syn keyword ghdVerb pushed
syn keyword ghdVerb opened
syn keyword ghdVerb closed
syn keyword ghdVerb forked
syn keyword ghdVerb created
syn keyword ghdVerb updated
syn keyword ghdVerb started

syn keyword ghdNoun gist
syn keyword ghdNoun issue
syn keyword ghdNoun commit
syn keyword ghdNoun commits

syn match ghdPullRequest /pull\ request/

" colors
if version >= 508 || !exists("did_conf_syntax_inits")
  if version < 508
    let did_todo_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ghdVerb Type
  HiLink ghdUser Constant
  HiLink ghdURL Comment

  HiLink ghdNoun Statement
  HiLink ghdIssueNumber Statement
  HiLink ghdPullRequest Statement

endif

let b:current_syntax = "githubdashboard"
