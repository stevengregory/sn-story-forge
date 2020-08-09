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

    def build_story(item, story_path)
      story_number = item['number']
      state_path = item['state'].to_s.downcase
      file_path = "#{story_path}#{state_path}/#{story_number}.md"
      StoryForge::Util.new.make_directory story_path
      StoryForge::Util.new.make_directory story_path + state_path
      File.write(file_path, Template.new.markdown_template(item))
    end

    def get_stories
      config = StoryForge::Config.story_options
      story_path = config[:path]
      StoryForge::Util.new.remove_files story_path
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/rm_story"
      response = RestClient.get url, params: config[:filter], authorization: auth
      data = JSON.parse(response.body)
      data['result'].first(config[:limit]).map do |item|
        build_story item, story_path
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
