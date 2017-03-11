#!/usr/local/bin/ruby

require "net/http"
require "uri"
require 'json'
require 'georuby'
require 'geo_ruby/ewk'
require 'geo_ruby/geojson'

module CrimeType
  Homicide = 1
  Assault = 8
  Robbery = 14
  OtherOffencesAgainstThePerson = 17
  UnlawfulEntry = 21
  Arson = 27
  OtherPropertyDamage = 28
  UnlawfulUseOfMotorVehicle = 29
  OtherTheft = 30
  Fraud = 35
  HandlingStolenGoods = 39
  DrugOffence = 45
  Liquor = 47
  WeaponsActOffences = 51
  GoodOrderOffence = 52
  TrafficAndRelatedOffences = 54
  Other = 55
end

start_date = 1483228800
end_date = 1514764800

suburb = "woolloongabba"

boundary_uri = URI.parse("https://data.police.qld.gov.au/api/boundary?name=#{suburb}")
boundary_response = Net::HTTP.get_response(boundary_uri)

json = JSON.parse(boundary_response.body)

if json['Success']
  suburb_id = json['Result'][0]['QldSuburbId']

  crime_uri = URI.parse("https://data.police.qld.gov.au/api/qpsmeshblock?boundarylist=1_#{suburb_id}&startdate=#{start_date}&enddate=#{end_date}&offences=1,8,14,17,21,27,28,29,30,35,39,45,47,51,52,54,55")

  crime_response = Net::HTTP.get_response(crime_uri)
  crimes = JSON.parse(crime_response.body)
  factory = GeoRuby::SimpleFeatures::GeometryFactory::new
  ewkt_parser = GeoRuby::SimpleFeatures::EWKTParser::new(factory)

  crimes['Result'].each do |crime|
    offence = crime['OffenceInfo'][0]['QpsOffenceCode']
    ewkt_parser.parse(crime['GeometryWKT'])
    print factory.geometry.to_json
    print "\n"
  end
end
