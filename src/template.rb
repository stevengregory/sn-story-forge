# frozen_string_literal: true

require 'reverse_markdown'

module StoryForge
  class Template
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
  end
end
