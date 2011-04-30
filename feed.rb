# encoding: utf-8
require 'net/http'
require 'uri'
require 'json'
require 'yaml'


class Feed
  attr_reader :content
  def initialize user = '', token = ''
    if user.empty? or token.empty?
      user, token = read_git_config
    end
    raise "Missing Github credentials" if user.empty? or token.empty?
    @url = URI.parse "https://github.com/#{user}.private.json?token=#{token}"
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
      http = Net::HTTP.new(@url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(@url.request_uri)

      @content = JSON.parse http.request(request).body

    rescue => e
      puts e.inspect
      @content = { :state => 'error', :message => 'Wrong credentials?'}
    end

    self
  end

  def to_list
    @content.map do |event|
      event_to_string event
    end
  end


  def event_to_string event
    ot = "#{event['url'] || 'X'}|#{event['created_at']}|#{event['actor']} "
    ot = "#{event['type']}|#{event['created_at']}|#{event['actor']} "
    ot << case event['type']
          when 'PushEvent'
            "pushed #{event['payload']['size']} commit#{event['payload']['size'] > 1 ? 's' : ''} to #{event['payload']['repo']}"
          when 'PullRequestEvent'
            "#{event['payload']['action']} pull request in #{event['payload']['repo']}"
          when 'IssuesEvent'
            "#{event['payload']['action']} issue ##{event['payload']['number']} in #{event['payload']['repo']}"
          when 'IssueCommentEvent'
            "commented in #{event['payload']['repo']}"
          when 'CommitCommentEvent'
            "commented on commit #{event['payload']['commit'][0..6]} in #{event['payload']['repo']}"
          when 'WatchEvent'
            "#{event['payload']['action']} watching #{event['payload']['repo']}"
          when 'FollowEvent'
            "started following #{event['payload']['target']['login']}"
          else
            " ¯\(°_o)/¯"
          end
  end
end
