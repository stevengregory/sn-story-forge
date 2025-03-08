# frozen_string_literal: true

require 'dotenv'

module StoryForge
  module Config
    module_function

    def directory_options
      {
        archive: 'Archive',
        default: 'All',
        my_stories: 'My Stories',
        path: 'dist',
        product: 'Product'
      }
    end

    def story_options
      {
        filter: {
          epic: ENV['EPIC'] || 'My Epic',
          sysparm_display_value: 'true'
        },
        limit: (ENV['STORY_LIMIT'] || 25).to_i
      }
    end

    def user_options
      {
        name: ENV['USER_NAME'] || 'Abel Tuter'
      }
    end

    def work_note_options(sys_id)
      {
        filter: {
          active: 'true',
          element: 'work_notes',
          element_id: sys_id,
          sysparm_display_value: 'true'
        },
        limit: (ENV['WORK_NOTES_LIMIT'] || 20).to_i
      }
    end
  end
end
