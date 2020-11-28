# frozen_string_literal: true

require 'rest-client'
require 'yaml'

require_relative 'config'
require_relative 'request'
require_relative 'template'
require_relative 'utils'

module StoryForge
  class Story
    def initialize
      @dir_config = StoryForge::Config.directory_options
      @story_config = StoryForge::Config.story_options
    end

    def archive_story(item, story_path)
      archive_path = "#{story_path}/#{@dir_config[:archive]}/#{item['number']}.yml"
      StoryForge::Utils.new.make_directory File.join(story_path, @dir_config[:archive])
      File.write(archive_path, item.to_yaml)
    end

    def build_story(item, story_path)
      product = item['product']['display_value']
      project = product ? product.to_s : @dir_config[:default]
      state_path = item['state'].to_s.capitalize
      file_path = "#{story_path}/#{@dir_config[:product]}/#{project}/#{state_path}/#{item['number']}.md"
      StoryForge::Utils.new.make_directory File.join(story_path, @dir_config[:product], project, state_path)
      File.write(file_path, Template.new.markdown_template(item))
    end

    def delete_stories
      StoryForge::Utils.new.remove_files File.join(@dir_config[:path], @dir_config[:product], @story_config[:filter][:product])
    end

    def forge
      delete_stories
      fetch_stories
    end

    def fetch_stories
      data = StoryForge::Request.new.fetch 'rm_story', @story_config[:filter]
      data['result'].first(@story_config[:limit]).map do |item|
        build_story item, @dir_config[:path]
        archive_story item, @dir_config[:path]
      end
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    def fetch_work_notes(sys_id, config)
      data = StoryForge::Request.new.fetch 'sys_journal_field', config[:filter]
      if data['result'][0] && data['result'][0].count > 1
        notes = data['result'].sort_by { |key| key['sys_created_on'] }.first(config[:limit]).map do |item|
          "---\n\n#### #{item['sys_created_by']}\n\n#{item['value']}\n\n_#{item['sys_created_on']}_\n\n---"
        end
        notes.join
      end
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
