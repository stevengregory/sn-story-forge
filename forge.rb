# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'

host = ENV['HOST']
user = ENV['USERNAME']
pwd = ENV['PASSWORD']

begin
  auth = "Basic #{Base64.strict_encode64("#{user}:#{pwd}")}"
  filter = { active: 'true' }
  table = "#{host}/api/now/table/incident"
  response = RestClient.get table, params: filter, authorization: auth
  data = JSON.parse(response.body)

  data['result'].map do |item|
    puts item['number']
  end

rescue => e
  puts "ERROR: #{e}" end
