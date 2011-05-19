if version < 600
  syntax clear
elseif exists("b:current_syntax")
    finish
  endif

syn match   ghdUser   /@[a-zA-Z0-9\-]*/
syn match   ghdURL /https:\/\/[a-zA-Z0-9\,\?\&\-\.\/_\#]*/

syn match   ghdIssueNumber /#[0-9]*/

syn match   ghdCommitDot /^\t\*/


syn keyword ghdNoun gist
syn keyword ghdNoun issue
syn keyword ghdNoun tag
syn keyword ghdNoun commit
syn keyword ghdNoun file
syn keyword ghdNoun commits

syn match   ghdPullRequest /pull\ request/

" colors
if version >= 508 || !exists("did_conf_syntax_inits")
  if version < 508
    let did_todo_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ghdUser Type
  HiLink ghdURL Folded

  HiLink ghdNoun Statement
  HiLink ghdPullRequest Statement
  HiLink ghdCommitDot Statement

  HiLink ghdIssueNumber String

  delcommand HiLink
endif

let b:current_syntax = "githubdashboard"
