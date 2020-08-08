# frozen_string_literal: true

require 'dotenv/load'
require_relative 'forge'

module StoryForge
  Story.get_stories ENV['HOST'], ENV['USERNAME'], ENV['PASSWORD']
end
