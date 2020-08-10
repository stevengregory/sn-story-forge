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
      @config = StoryForge::Config::story_options
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
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/rm_story"
      response = RestClient.get url, params: @config[:filter], authorization: auth
      data = JSON.parse(response.body)
      data['result'].first(@config[:limit]).map do |item|
        build_story item, @config[:path]
      end
      rescue RestClient::ExceptionWithResponse => e
        e.response
    end

    def get_work_notes(sysId, config)
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/sys_journal_field"
      response = RestClient.get url, params: config[:filter], authorization: auth
      data = JSON.parse(response.body)
      notes = data['result'].sort_by {|k, v| k['sys_created_on']}.first(config[:limit]).map do |item|
        "---\n\n#### #{item['sys_created_by']}\n\n#{item['value']}\n\n_#{item['sys_created_on']}_\n\n---"
      end
      return notes.join()
      rescue RestClient::ExceptionWithResponse => e
        e.response
    end

    def forge
      StoryForge::Util.new.remove_files @config[:path]
      get_stories
    end
  end
end
