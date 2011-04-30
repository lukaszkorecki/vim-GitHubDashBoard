if exists('g:loaded_autoload_github_dashboad') || v:version < 702
  finish
endif
let g:loaded_autoload_github_dashboad = 1

function! g:GetGithubDashboard()
ruby << EOF
  load('feed.rb')
  require 'tempfile'
  f = ''
  Tempfile.new(Time.now.to_i) do |file|
    f = file.path
    file.write Feed.new.download.to_list
  end

  VIM::set_option 'errorformat=%f|%m'
  VIM::command "silent execute 'cgetfile #{f}'"
  VIM::command 'copen'
EOF
endfunction

command! -bar -narg=* GetGitDash call g:GetGithubDashboard()
