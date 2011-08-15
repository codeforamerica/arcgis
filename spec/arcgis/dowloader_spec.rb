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

end