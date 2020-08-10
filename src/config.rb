# frozen_string_literal: true

module StoryForge
  class Config
    class << self
      def story_options
        {
          filter: {
            assigned_to: 'Steven Gregory',
            sysparm_display_value: 'true'
          },
          limit: 15,
          path: 'stories/'
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
          limit: 10
        }
      end
    end
  end
end
