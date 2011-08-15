$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'arcgis'
require 'rspec'
require 'webmock/rspec'

$host = "http://examplesite.com/arcgis/path"

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def a_json_get(path,query_params={})
  url = "#{$host}#{"/" unless path.empty?}#{path}"
  query = query_params.merge("f"=>"json")
  a_request(:get,url).with(:query=>query)
end

def stub_json_get(path,query_params={})
  url = "#{$host}#{"/" unless path.empty?}#{path}"
  query = query_params.merge("f"=>"json")
  stub_request(:get,url).with(:query=>query)
end