# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'
require 'reverse_markdown'
require 'fileutils'

host = ENV['HOST']
user = ENV['USERNAME']
pwd = ENV['PASSWORD']
table = ENV['TABLE']

@path = 'stories/'

def acceptance_criteria item
  ReverseMarkdown.convert item['acceptance_criteria'].strip
end

def get_short_description item
  "#{item['short_description']}\n\n"
end

def get_state item
  "## 🚀 State\n\n#{item['state']}\n\n"
end

def get_story_points item
  unless item['story_points'].to_s.empty?
    "## 🧮 Story Points\n\n#{item['story_points']}\n\n"
  end
end

def remove_files path
  FileUtils.rm_rf Dir.glob("#{path}*")
end

def do_template story, short_description, description, ac, assigned_to, story_points, state, created_by, last_updated
  [
    story,
    short_description,
    description,
    ac,
    assigned_to,
    story_points,
    state,
    created_by,
    last_updated
  ]
end

def map_fields

end

begin
  auth = "Basic #{Base64.strict_encode64("#{user}:#{pwd}")}"
  filter = {
    active: 'true',
    assigned_to: '6f0d65f5db0332008798ffa31d961945',
    sysparm_display_value: 'true'
  }
  limit = 5
  table = "#{host}/api/now/table/#{table}"
  response = RestClient.get table, params: filter, authorization: auth
  data = JSON.parse(response.body)

  remove_files @path

  data['result'].first(limit).map do |item|
    ac = "## ✅ Acceptance Criteria\n\n#{acceptance_criteria item}"
    assigned_to = "## 😀 Assigned To\n\n#{item['assigned_to']['display_value']}\n\n"
    created_by = "## 🌱 Created By\n\n#{item['sys_created_by']}\n\n"
    description = "## 📋 Description\n\n#{item['description']}\n\n"
    last_updated = "## 🗓️ Last Updated\n\n#{item['sys_updated_on']} by #{item['sys_updated_by']}\n"
    story = "# [#{item['number']}](#{ENV['HOST']}/nav_to.do?uri=rm_story.do?sys_id=#{item['sys_id']}%26sysparm_view=scrum)\n\n"
    template = do_template(
      story,
      get_short_description(item),
      description,
      ac,
      assigned_to,
      get_story_points(item),
      get_state(item),
      created_by,
      last_updated).join
    File.write("#{@path}#{item['number']}.md", template)
  end

rescue => e
  puts "ERROR: #{e}" end
