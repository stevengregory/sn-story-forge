# frozen_string_literal: true

require 'json'
require 'rest-client'
require 'yaml'
require_relative 'config'
require_relative 'request'
require_relative 'template'
require_relative 'util'

module StoryForge
  class Story
    def initialize
      @config = StoryForge::Config.story_options
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
    end

    def delete_stories
      StoryForge::Util.new.remove_files File.join(@config[:path], @config[:product])
    end

    def forge
      delete_stories
      get_stories
    end

    def get_stories
      response = StoryForge::Request.new.do_request 'rm_story', @config[:filter]
      data = JSON.parse(response.body)
      data['result'].first(@config[:limit]).map do |item|
        build_story item, @config[:path]
        archive_story item, @config[:path]
      end
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    def get_work_notes(sysId, config)
      response = StoryForge::Request.new.do_request 'sys_journal_field', config[:filter]
      data = JSON.parse(response.body)
      notes = data['result'].sort_by {|key| key['sys_created_on']}.first(config[:limit]).map do |item|
        "---\n\n#### #{item['sys_created_by']}\n\n#{item['value']}\n\n_#{item['sys_created_on']}_\n\n---"
      end
      notes.join()
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
