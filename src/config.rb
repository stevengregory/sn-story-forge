# frozen_string_literal: true

module StoryForge
  module Config
    module_function

    def directory_options
      {
        archive: 'Archive',
        path: '/Users/steven.gregory/Desktop/Story Forge',
        product: 'Product'
      }
    end

    def story_options
      {
        filter: {
          assigned_to: 'Steven Gregory',
          sysparm_display_value: 'true'
        },
        limit: 50
      }
    end

    def work_note_options(sysId)
      {
        filter: {
          active: 'true',
          element: 'work_notes',
          element_id: sysId,
          sysparm_display_value: 'true'
        },
        limit: 20
      }
    end
  end
end
