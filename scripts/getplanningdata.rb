#!/usr/bin/ruby

require "net/http"
require "uri"
require 'json'
require 'georuby'
require 'geo_ruby/ewk'
require 'geo_ruby/geojson'

key = ENV['PLANNINGALERTS_KEY']
state = "QLD"
suburb = "Woolloongabba"

uri = URI.parse("https://api.planningalerts.org.au/applications.js?key=#{key}&state=#{state}&suburb=#{suburb}")

response = Net::HTTP.get_response(uri)

json = JSON.parse(response.body)

print json
