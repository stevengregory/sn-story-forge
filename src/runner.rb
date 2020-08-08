# frozen_string_literal: true

require 'dotenv/load'
require_relative 'story'

module StoryForge
  Story.get_stories ENV['HOST'], ENV['USERNAME'], ENV['PASSWORD']
end
