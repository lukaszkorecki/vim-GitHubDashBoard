if exists('g:loaded_autoload_github_dashboad') || v:version < 702
  finish
endif
let g:loaded_autoload_github_dashboad = 1

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

function! s:GetGithubDashboard()
ruby << EOF
  require 'tempfile'
  require 'fileutils'

  # encoding: utf-8
  require 'net/http'
  require 'uri'
  require 'rubygems'
  require 'json'


  class Feed
    attr_reader :content
    def initialize user = '', token = ''
      if user.empty? or token.empty?
        user, token = read_git_config
      end
      raise "Missing Github credentials" if user.empty? or token.empty?
      @url = URI.parse "https://github.com/#{user}.private.json?token=#{token}"
      VIM::message @url
      self
    end

    def read_git_config
      [
        `git config -f ~/.gitconfig --get github.user`,
        `git config -f ~/.gitconfig --get github.token`
      ].map { |e| e.chomp.strip }
    end

    def download
      begin
        body = `curl --silent #{@url}`
        @content = JSON.parse body
        puts @content.first['type']

      rescue => e
        puts e.inspect
        VIM::message e.inspect
        @content = nil
      end

      self
    end

    def to_list
      VIM::message 'Error when downloading feed!'  if @content.nil?
      @content.map { |event| event_to_string event } unless @content.nil?
    end


    def event_to_string event
      ot = "#{event['actor']} "
      ot << case event['type']
            when 'ForkEvent'
              "forked #{event['payload']['repo']}"
            when 'PushEvent'
              "pushed #{event['payload']['size']} commit#{event['payload']['size'] > 1 ? 's' : ''} to #{event['payload']['repo']}"
            when 'PullRequestEvent'
              "#{event['payload']['action']} pull request in #{event['payload']['repo']}"
            when 'IssuesEvent'
              "#{event['payload']['action']} issue ##{event['payload']['number']} in #{event['payload']['repo']}"
            when 'IssueCommentEvent'
              s = "commented an issue in #{event['payload']['repo']} | #{event['url']}#{event['payload']['repo']}/issues"
              event['url'] = ''
              s
            when 'CommitCommentEvent'
              "commented on commit #{event['payload']['commit'][0..6]} in #{event['payload']['repo']}"
            when 'WatchEvent'
              "#{event['payload']['action']} watching #{event['payload']['repo']}"
            when 'FollowEvent'
              "started following #{event['payload']['target']['login']}"
            else
              " ¯\(°_o)/¯ - unknown event #{event['type']}"
            end
      ot << " | #{event['url']}" unless event['url'].nil? or event['url'].empty?

      ot
    end
  end

  f = VIM::evaluate 'tempname()'
  VIM::message 'Downloading information...'
  content = Feed.new.download.to_list.join("\n")

  File.open(f, 'w') { |file| file.write  content }

  VIM::set_option 'errorformat=%f|%m'
  VIM::command "silent execute 'cgetfile #{f}'"
  VIM::command 'copen'

  # alternative way
  # VIM::command "e #{f}"
  # VIM::set_option 'nomodifiable'
EOF
endfunction

command! -bar -narg=* GithubDash call s:GetGithubDashboard()
command! -bar -narg=* GithubOpen call s:OpenInBrowser()
