function! s:OpenInBrowser()
ruby << EOF
  url = VIM::Buffer.current.line.split('|').last
  cmd = case  RUBY_PLATFORM
        when /darwin/
          "open"
        when /linux/
          "xdg-open"
        end
  VIM::command "silent ! #{cmd} #{url}"
EOF
endfunction

command! -bar -nargs=0 GithubOpen call <SID>OpenInBrowser()
map  <buffer> <leader>o :call <SID>OpenInBrowser()<cr>

" Placeholder stuff
function! s:OpenUserProfile()
  let s:user = expand('<cword>')
ruby << EOF
  user = VIM::evaluate("expand('<cword>')")

  if VIM::Buffer.current.line =~ /^@#{user}/
    url = "https://github.com/"+user
    cmd = case  RUBY_PLATFORM
          when /darwin/
            "open"
          when /linux/
            "xdg-open"
          end
    VIM::command "silent ! #{cmd} #{url}"
  else
    VIM::message "Not a user!"
  end
EOF
endfunction

command! -bar -nargs=0 GithubUser call <SID>OpenUserProfile()
map  <buffer> <leader>u :call <SID>OpenUserProfile()<cr>
