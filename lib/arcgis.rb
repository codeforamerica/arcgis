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
    #it's a bit hacky. it depends on OBJECTID being present, to 'scroll' through.
    def download_layer(service_name,id)
      path = [service_name,"MapServer",id,"query"]*"/"

      get_page = Proc.new do |page|
        @connection.get do |req|
          req.url(path)
          req.params["where"] = "(OBJECTID>=#{page*@max_results}) AND (OBJECTID<#{(1+page)*@max_results})"
          req.params["returnGeometry"] = true
        end.body
      end

      current_page = 0
      initial_results = get_page[current_page]

      features = initial_results.delete("features") #initial_results now has just the headers
      all_features = features

      #while we're still getting results, download the next page.
      #there could be gaps, so we have to keep going until we know we've hit the top OID.
      #this requires a messy loop/break, unless I can figure out something cleaner.
      #WARNING: slow for large data sets. TODO: make parallel
      loop do
        current_page+=1
        features = get_page[current_page]["features"]
        all_features += features

        if features.length < @max_results #we less than max results. we could be done, or we could be in a gap.
          #get everything above this page, see if we're really done.
          above_us = @connection.get {|r| r.url(path); r.params["where"] = "OBJECTID>=#{(current_page+1)*@max_results}"}.body
          above_features = above_us["features"]
          break if (above_features.nil? or above_features.empty?) #if there's no features above us, we're done. break the loop.
        end
      end

      #we've downloaded all the features. return the result. initial_results has the header.
      return initial_results.merge("features"=>all_features)
    end

  end
end
