# frozen_string_literal: true

require 'base64'
require 'json'
require 'rest-client'
require 'fileutils'
require 'yaml'
require_relative 'template'

module StoryForge
  class Forge
    def self.remove_files(path)
      FileUtils.rm_rf Dir.glob("#{path}*")
    end

    def self.do_request(host, user_name, password)
      config = YAML.load_file('src/config.yml')
      auth = "Basic #{Base64.strict_encode64("#{user_name}:#{password}")}"
      url = "#{host}/api/now/table/#{config['table']}"
      response = RestClient.get url, params: config['filter'], authorization: auth
      data = JSON.parse(response.body)

      remove_files config['path'] if File.directory?(config['path'])

      data['result'].first(config['limit']).map do |item|
        dir_path = item['state'].to_s.downcase
        FileUtils.mkdir_p(config['path']) if !File.directory?(config['path'])
        Dir.mkdir config['path'] + dir_path if !File.directory?(config['path'] + dir_path)
        file_path = "#{config['path']}#{dir_path}/#{item['number']}.md"
        File.write(file_path, Template.get_markdown_template(item))
      end
      rescue RestClient::ExceptionWithResponse => e
        e.response
    end
  end
end
