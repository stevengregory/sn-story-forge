# frozen_string_literal: true

require 'fileutils'
require 'reverse_markdown'

module StoryForge
  class Util
    def convert_to_markdown(item, field)
      ReverseMarkdown.convert item[field]
    end

    def make_directory(path)
      FileUtils.mkdir_p(path, verbose: true) unless File.exist?(path)
    end

    def remove_files(path)
      FileUtils.rm_rf Dir.glob("#{path}*") if File.directory?(path)
    end
  end
end
