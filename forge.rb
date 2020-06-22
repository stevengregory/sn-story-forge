# frozen_string_literal: true

require 'base64'
require 'dotenv/load'
require 'json'
require 'rest-client'

host = ENV['HOST']
user = ENV['USERNAME']
pwd = ENV['PASSWORD']

begin
  response = RestClient.get "#{host}/api/now/table/incident", params: { active: 'true' }, :authorization => "Basic #{Base64.strict_encode64("#{user}:#{pwd}")}"
  data = JSON.parse(response.body)

  data['result'].map do |item|
    puts item['number']
  end

rescue => e
  puts "ERROR: #{e}" end