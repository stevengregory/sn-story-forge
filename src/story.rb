# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'
require 'yaml'
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

    def archive_story(item, story_path)
      archive_path = "#{story_path}/#{@config[:archive]}/#{item['number']}.yml"
      StoryForge::Util.new.make_directory File.join(story_path, @config[:archive])
      File.write(archive_path, item.to_yaml)
    end

    def build_story(item, story_path)
      project = item['assignment_group']['display_value'].to_s
      state_path = item['state'].to_s.capitalize
      file_path = "#{story_path}/#{@config[:product]}/#{project}/#{state_path}/#{item['number']}.md"
      StoryForge::Util.new.make_directory File.join(story_path, @config[:product], project, state_path)
      File.write(file_path, Template.new.markdown_template(item))
      archive_story item, story_path
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
      StoryForge::Util.new.remove_files File.join(@config[:path], @config[:product])
      get_stories
    end
  end
end
