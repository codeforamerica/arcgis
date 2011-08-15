require 'helper'

describe ArcGIS::Downloader do

  before :each do
    @downloader = ArcGIS::Downloader.new($host)
  end

  describe "index" do
    it "should fetch the top-level page" do
      stub_json_get("").to_return(:status => 200, :body => fixture("index.json"))
      r=@downloader.index
      a_json_get("").should have_been_made
      r["folders"].should include "base_maps"
    end
  end

  describe "each_service" do
    it "should fetch all service descriptors, recursively" do
      stub_json_get("").to_return(:status => 200, :body => fixture("small_index.json"))
      stub_json_get("folder1").to_return(:status => 200, :body => fixture("folder1.json"))
      stub_json_get("folder2").to_return(:status => 200, :body => fixture("folder2.json"))

      all_services = @downloader.each_service.to_a
      ["","folder1","folder2"].each {|p| a_json_get(p).should have_been_made}

      all_services.length.should == 4 #there are 4 services in total. 1 in index, 1 in folder1, 2 in folder2
      all_services.select {|path,name,type| path.empty?}.length.should == 1 #there should be 1 service with an empty path - the one from the index
    end

    #TODO: need to find real-world example of sub-folder setup, test it.
  end

end