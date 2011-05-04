if exists('g:loaded_autoload_github_dashboad') || v:version < 702
  finish
endif
let g:loaded_autoload_github_dashboad = 1


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
      ot = "@#{event['actor']} "
      payload = event['payload']
      ot << case event['type']
            when 'ForkEvent'
              "forked #{payload['repo']}"

            when 'PushEvent'
              "pushed #{payload['size']} commit#{payload['size'] > 1 ? 's' : ''} to #{payload['repo']}"

            when 'PullRequestEvent'
              id = event['url'].split('/').last
              "#{payload['action']} pull request ##{id} in #{payload['repo']}"

            when 'IssuesEvent'
              "#{payload['action']} issue ##{payload['number']} in #{payload['repo']}"

            when 'IssueCommentEvent'
              url = event['url']
              event['url'] = ''
              "commented an issue on #{payload['repo']} | #{url}#{payload['repo']}/issues"

            when 'CommitCommentEvent'
              "commented on #{payload['repo']} (#{payload['commit'][0..6]})"

            when 'DownloadEvent'
              "uploaded #{payload['url'].split('/').last} to #{event['repository']['homepage']}"

            when 'GistEvent'
              event['url'] = payload['url']
              "#{(payload['action']+'ed').sub('eed', 'ed')} a gist"

            when 'WatchEvent'
              "#{payload['action']} watching #{payload['repo']}"

            when 'FollowEvent'
              event['url'] = "http://github.com/#{payload['target']['login']}"
              "started following @#{payload['target']['login']}"

            when 'CreateEvent'
              "created a tag #{payload['object_name']} in #{payload['name']}"

            when 'GollumEvent'
              "#{payload['action']} wiki: '#{payload['page_name']}' in #{payload['repo']}"

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

  # alternative way
  VIM::command "sp"
  VIM::command "e #{f}"
  VIM::command 'w!'
  VIM::command 'setlocal nomodifiable'
  VIM::command "setlocal ft=githubdashboard"

EOF
endfunction

command! -bar -narg=* GithubDash call s:GetGithubDashboard()
