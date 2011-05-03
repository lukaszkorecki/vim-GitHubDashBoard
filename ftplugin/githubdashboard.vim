function! s:OpenInBrowser()
ruby << EOF
  url = VIM::Buffer.current.line.split('|').last
  VIM::message  "Opening #{url} in your default browser"
  cmd = case  RUBY_PLATFORM
        when /darwin/
          "open"
        when /linux/
          "xdg-open"
        end
  VIM::message `#{cmd} #{url}`
EOF
endfunction

command! -bar -nargs=0 GithubOpen call <SID>OpenInBrowser()
map  <buffer> <leader>o :call <SID>OpenInBrowser()<cr>

" Placeholder stuff
function! s:OpenUserProfile()
ruby << EOF
  url = VIM::Buffer.current.line.split('|').last
  VIM::message  "Opening #{url} in your default browser"
  cmd = case  RUBY_PLATFORM
        when /darwin/
          "open"
        when /linux/
          "xdg-open"
        end
  VIM::message `#{cmd} #{url}`
EOF
endfunction
