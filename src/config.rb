# frozen_string_literal: true

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
          epic: 'My Epic',
          sysparm_display_value: 'true'
        },
        limit: 25
      }
    end

    def user_options
      {
        name: 'Steven Gregory'
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
        limit: 20
      }
    end
  end
end
