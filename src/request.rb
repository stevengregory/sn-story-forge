# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'

require_relative 'utils'

module StoryForge
  class Request
    def initialize
      @instance = ENV['INSTANCE']
      @user_id = ENV['USER_ID']
      @password = ENV['PASSWORD']
    end

    def fetch(table, filter)
      auth = "Basic #{Base64.strict_encode64("#{@user_id}:#{@password}")}"
      url = "#{Utils.new.build_instance_url @instance}/api/now/table/#{table}"
      response = RestClient.get url, params: filter, authorization: auth
      JSON.parse(response.body)
    end
  end
end
