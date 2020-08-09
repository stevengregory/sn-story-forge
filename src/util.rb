# frozen_string_literal: true

require 'reverse_markdown'
require 'fileutils'

module StoryForge
  class Util
    def convert_to_markdown(item, field)
      ReverseMarkdown.convert item[field].strip
    end

    def make_directory(path)
      Dir.mkdir(path) if !File.directory?(path)
    end

    def remove_files(path)
      FileUtils.rm_rf Dir.glob("#{path}*") if File.directory?(path)
    end
  end
end
