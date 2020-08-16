# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'

module StoryForge
  class Request
    def initialize
      @instance = ENV['INSTANCE']
      @user_name = ENV['USERNAME']
      @password = ENV['PASSWORD']
    end

    def do_request(table, filter)
      auth = "Basic #{Base64.strict_encode64("#{@user_name}:#{@password}")}"
      url = "https://#{@instance}.service-now.com/api/now/table/#{table}"
      response = RestClient.get url, params: filter, authorization: auth
      JSON.parse(response.body)
    end
  end
end
