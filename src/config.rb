# frozen_string_literal: true

module StoryForge
  class Config
    class << self
      def story_options
        {
          filter: {
            active: 'true',
            assigned_to: '6f0d65f5db0332008798ffa31d961945',
            sysparm_display_value: 'true'
          },
          limit: 10,
          path: 'stories/'
        }
      end

      def work_note_options(sysId)
        {
          filter: {
            active: 'true',
            element: 'work_notes',
            element_id: sysId,
            sysparm_display_value: 'true',
          },
          limit: 5
        }
      end
    end
  end
end
