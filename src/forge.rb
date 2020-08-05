# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'
require 'reverse_markdown'
require 'fileutils'

@path = 'stories/'

def convert_to_markdown(item, field)
  ReverseMarkdown.convert item[field].strip
end

def get_markdown_template(item)
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

def get_acceptance_criteria(item)
  "## ✅ Acceptance Criteria\n\n#{convert_to_markdown item, 'acceptance_criteria'}"
end

def get_assigned_to(item)
  "## 😀 Assigned To\n\n#{item['assigned_to']['display_value']}\n\n"
end

def get_created_by(item)
  "## 🌱 Created By\n\n#{item['sys_created_by']}\n\n"
end

def get_description(item)
  "## 📋 Description\n\n#{item['description']}\n\n"
end

def get_last_updated(item)
  "## 🗓️ Last Updated\n\n#{item['sys_updated_on']} by #{item['sys_updated_by']}\n"
end

def get_short_description(item)
  "#{item['short_description']}\n\n"
end

def get_state(item)
  "## 🚀 State\n\n#{item['state']}\n\n"
end

def get_story(item)
  "# [#{item['number']}](#{ENV['HOST']}/nav_to.do?uri=rm_story.do?sys_id=#{item['sys_id']}%26sysparm_view=scrum)\n\n"
end

def get_story_points(item)
  "## 🧮 Story Points\n\n#{item['story_points']}\n\n" if !item['story_points'].to_s.empty?
end

def remove_files(path)
  FileUtils.rm_rf Dir.glob("#{path}*")
end

def do_request(host, user_name, password)
  begin
    auth = "Basic #{Base64.strict_encode64("#{user_name}:#{password}")}"
    user = '6f0d65f5db0332008798ffa31d961945'
    filter = {
      active: 'true',
      assigned_to: user,
      sysparm_display_value: 'true'
    }
    table = 'rm_story'
    limit = 5
    table = "#{host}/api/now/table/#{table}"
    response = RestClient.get table, params: filter, authorization: auth
    data = JSON.parse(response.body)

    remove_files @path if File.directory?(@path)

    data['result'].first(limit).map do |item|
      dir_path = item['state'].to_s.downcase
      FileUtils.mkdir_p(@path) if !File.directory?(@path)
      Dir.mkdir @path + dir_path if !File.directory?(@path + dir_path)
      file_path = "#{@path}#{dir_path}/#{item['number']}.md"
      File.write(file_path, get_markdown_template(item))
    end
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

do_request ENV['HOST'], ENV['USERNAME'], ENV['PASSWORD']
