require "faraday"
require 'faraday_middleware'

module ArcGIS
  class Downloader

    def initialize(url)
      @connection = Faraday.new(:url=>url, :params=>{"f"=>"json"}) do |conn|
        conn.use Faraday::Response::ParseJson
        conn.adapter(Faraday.default_adapter)
      end
    end

    def index
      folder_index("")
    end

    def folder_index(path)
      @connection.get(path).body
    end

  end
end
