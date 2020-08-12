# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'rest-client'

module StoryForge
  class Request
    def initialize
      @host = ENV['HOST']
      @user_name = ENV['USERNAME']
      @password = ENV['PASSWORD']
    end

    def do_request(table, filter)
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "#{@host}/api/now/table/#{table}"
      RestClient.get url, params: filter, authorization: auth
    end
  end
end
