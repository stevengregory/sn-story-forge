# frozen_string_literal: true

require 'base64'
require 'json'
require 'rest-client'
require 'reverse_markdown'
require 'fileutils'
require 'yaml'

module StoryForge
  class Forge
    def self.convert_to_markdown(item, field)
      ReverseMarkdown.convert item[field].strip
    end

    def self.get_markdown_template(item)
      [
        get_story(item),
        get_short_description(item),
        get_description(item),
        get_acceptance_criteria(item),
        get_assigned_to(item),
        get_story_points(item),
        get_state(item),
        get_created_by(item),
        get_last_updated(item)
      ].join
    end

    def self.get_acceptance_criteria(item)
      "## ✅ Acceptance Criteria\n\n#{convert_to_markdown item, 'acceptance_criteria'}"
    end

    def self.get_assigned_to(item)
      "## 😀 Assigned To\n\n#{item['assigned_to']['display_value']}\n\n"
    end

    def self.get_created_by(item)
      "## 🌱 Created By\n\n#{item['sys_created_by']}\n\n"
    end

    def self.get_description(item)
      "## 📋 Description\n\n#{item['description']}\n\n"
    end

    def self.get_last_updated(item)
      "## 🗓️ Last Updated\n\n#{item['sys_updated_on']} by #{item['sys_updated_by']}\n"
    end

    def self.get_short_description(item)
      "#{item['short_description']}\n\n"
    end

    def self.get_state(item)
      "## 🚀 State\n\n#{item['state']}\n\n"
    end

    def self.get_story(item)
      "# [#{item['number']}](#{ENV['HOST']}/nav_to.do?uri=rm_story.do?sys_id=#{item['sys_id']}%26sysparm_view=scrum)\n\n"
    end

    def self.get_story_points(item)
      "## 🧮 Story Points\n\n#{item['story_points']}\n\n" if !item['story_points'].to_s.empty?
    end

    def self.remove_files(path)
      FileUtils.rm_rf Dir.glob("#{path}*")
    end

    def self.do_request(host, user_name, password)
      begin
        config = YAML.load_file('src/config.yml')
        auth = "Basic #{Base64.strict_encode64("#{user_name}:#{password}")}"
        url = "#{host}/api/now/table/#{config['table']}"
        response = RestClient.get url, params: config['filter'], authorization: auth
        data = JSON.parse(response.body)

        remove_files config['path'] + '*' if File.directory?(config['path'])

        data['result'].first(config['limit']).map do |item|
          dir_path = item['state'].to_s.downcase
          FileUtils.mkdir_p(config['path']) if !File.directory?(config['path'])
          Dir.mkdir config['path'] + dir_path if !File.directory?(config['path'] + dir_path)
          file_path = "#{config['path']}#{dir_path}/#{item['number']}.md"
          File.write(file_path, get_markdown_template(item))
        end
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end
  end
end
