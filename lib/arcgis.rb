module ArcGIS
  # Your code goes here...
  class Downloader

    def initialize(url)
      @connection = Faraday.new(:url=>url, :params=>{"f"=>"json"}) do |conn|
        conn.use Faraday::Response::ParseJson
        conn.adapter(Faraday.default_adapter)
      end
    end

    def index
      @connection.get("").body
    end

  end
end
