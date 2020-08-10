# frozen_string_literal: true

require_relative 'config'
require_relative 'story'
require_relative 'util'

module StoryForge
  class Template
    def markdown_template(item)
      [
        get_story(item),
        get_short_description(item),
        get_description(item),
        get_acceptance_criteria(item),
        get_assigned_to(item),
        get_story_points(item),
        get_state(item),
        get_created_by(item),
        get_last_updated(item),
        get_work_notes(item)
      ].join
    end

    def get_acceptance_criteria(item)
      "## ✅ Acceptance Criteria\n\n#{Util.new.convert_to_markdown item, 'acceptance_criteria'}"
    end

    def get_assigned_to(item)
      "## 😀 Assigned To\n\n#{item['assigned_to']['display_value']}\n\n"
    end

    def get_created_by(item)
      "## 🌱 Created By\n\n#{item['sys_created_by']}\n\n"
    end

    def get_description(item)
      "## 📋 Description\n\n#{item['description']}\n\n" if !item['description'].empty?
    end

    def get_last_updated(item)
      "## 🗓️ Last Updated\n\n#{item['sys_updated_on']} by #{item['sys_updated_by']}\n\n"
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

    def get_work_notes(item)
      config = StoryForge::Config::work_note_options(item['sys_id'])
      work_notes = StoryForge::Story.new.get_work_notes item['sys_id'], config
      "## 📝 Work Notes\n\n#{work_notes}" if !work_notes.to_s.empty?
    end
  end
end
