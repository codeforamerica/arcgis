#example: download all the map layers from an ArcGIS endpoint
require 'arcgis'

d = ArcGIS::Downloader.new("http://your_arc_server/ArcGIS/rest/services")

d.each_service do |path,service_name,type|
  STDERR.puts "looking at service: #{[path,service_name,type].inspect}"
  if type == "MapServer"
    d.each_layer(service_name) do |layer|
      STDERR.puts "\tdownloading layer: #{layer['name']}"
      results = d.download_layer(service_name,layer['id'])
      STDERR.puts "\tthat layer has #{results['features'].length} features"

      #code to write out to translate from hash/array to format of your choice,
      #write to filesystem, upload, etc.
    end
  end
end
