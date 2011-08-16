require "faraday"
require 'faraday_middleware'

module ArcGIS
  DEFAULT_MAX_RESULTS = 500

  class Downloader

    def initialize(url)
      @connection = Faraday.new(:url=>url, :params=>{"f"=>"json"}) do |conn|
        conn.use Faraday::Response::ParseJson
        conn.adapter(Faraday.default_adapter)
      end
      @max_results = DEFAULT_MAX_RESULTS
    end

    def index
      folder_index("")
    end

    def folder_index(path)
      @connection.get(path).body
    end

    def recursive_services(folder_path,&block)
      r = folder_index(folder_path*"/")

      r["services"].each do |service|
        yield folder_path,service["name"],service["type"]
      end

      r["folders"].each do |sub_folder|
        recursive_services(folder_path+[sub_folder],&block)
      end
    end

    def each_service(&block)
      Enumerator.new do |y|
        recursive_services([]) do |folder_path,name,type|
          y.yield(folder_path,name,type)
        end
      end.each(&block)
    end

    def service_index(name,type)
      @connection.get([name,type]*"/").body
    end

    #only for MapServer services
    def each_layer(service_name,&block)
      service_index(service_name,"MapServer")["layers"].each(&block)
    end

    #downloads a MapServer layer, respecting the rate limit
    def download_layer(service_name,id)
    end

  end
end
