function! s:OpenInBrowser()
ruby << EOF
  url = VIM::Buffer.current.line.split('|').last
  VIM::message  url
  cmd = case  RUBY_PLATFORM
        when /darwin/
          "open"
        when /linux/
          "xdg-open"
        end
  VIM::message `#{cmd} #{url}`
EOF

endfunction
if exists('g:loaded_autoload_github_dashboad') || v:version < 702
  finish
elseif
  command! -bar -nargs=0 GithubOpen call <SID>OpenInBrowser()
endif
