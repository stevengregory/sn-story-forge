#!/usr/bin/env ruby

require 'base64'

# https://rubygems.org/gems/rest-client # Example install using gem #   gem install rest-client require 'rest-client'

# Set the request parameters
host =  'https://myinstance.service-now.com'
user =  'admin'
pwd =  'admin'

begin # Get ALL incidents
 response = RestClient. get ( "#{host}/api/now/table/incident",
                            {:authorization  => "Basic #{Base64.strict_encode64(" #{user}:#{pwd}")}", :accept => 'application/json' } ) puts "#{response.to_str}" puts "Response status: #{response.code}"
 response. headers. each { |k,v | puts "Header: #{k}=#{v}" }

rescue => e
  puts "ERROR: #{e}" end