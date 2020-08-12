# frozen_string_literal: true

module StoryForge
  class Config
    class << self
      def story_options
        {
          archive: 'Archive',
          filter: {
            assigned_to: 'Steven Gregory',
            sysparm_display_value: 'true'
          },
          limit: 50,
          path: '/Users/steven.gregory/Desktop/Story Forge',
          product: 'Product'
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
end
