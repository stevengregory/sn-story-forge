# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'
require_relative 'config'
require_relative 'template'
require_relative 'util'

module StoryForge
  class Story

    def initialize
      @host = ENV['HOST']
      @user_name = ENV['USERNAME']
      @password = ENV['PASSWORD']
    end

    def get_stories
      config = Config.new.get_story_config
      story_path = config[:path]
      Util.remove_files story_path
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/rm_story"
      response = RestClient.get url, params: config[:filter], authorization: auth
      data = JSON.parse(response.body)
      data['result'].first(config[:limit]).map do |item|
        state_path = item['state'].to_s.downcase
        Dir.mkdir(story_path) if !File.directory?(story_path)
        Dir.mkdir story_path + state_path if !File.directory?(story_path + state_path)
        file_path = "#{story_path}#{state_path}/#{item['number']}.md"
        File.write(file_path, Template.new.get_markdown_template(item))
      end
      rescue RestClient::ExceptionWithResponse => e
        e.response
    end

    def get_work_notes(sysId, config)
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/sys_journal_field"
      response = RestClient.get url, params: config[:filter], authorization: auth
      data = JSON.parse(response.body)
      notes = data['result'].first(config[:limit]).map do |item|
        "#### #{item['sys_created_on']}\n\n#{item['value']}\n\n"
      end
      return notes.join()
      rescue RestClient::ExceptionWithResponse => e
        e.response
    end
  end
end
