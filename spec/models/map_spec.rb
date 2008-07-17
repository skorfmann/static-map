require File.dirname(__FILE__) + '/../spec_helper'

include StaticMap

describe Map do
  describe "beeing initialized" do
    before(:each) do
      @map = Map.new
      @marker = Marker.new(:position => [0,0])
    end
    
    it "should initilaize" do
      @map.should be
    end
  
    it "should have an empty array for markers" do
      @map.markers.should be_empty
    end
  
    it "should allow adding of markers" do
      @map.markers << @marker
      @map.should have(1).markers
      @map.markers.should == [@marker]
    end
    
    it "should initialize with marker" do
      @map = Map.new(:markers => [@marker])
      @map.markers.should == [@marker]
    end
    
    it "should initialize with key, zoom, span" do
      value = "just a value"
      for key in %w{key zoom span width height}
        @map = Map.new(key.to_sym => value)
        @map.send("#{key}").should == value
      end
    end
    
    it "should initialize with center" do
      center = [47, 11]
      @map = Map.new(:center => center)
      @map.center.should == center
    end
    
    it "should return image link on calling to_s" do
      key = "Justatest"
      @map.key = key
      link = @map.to_s
      link.should include("http://maps.google.com/staticmap?")
      link.should include("size=#{Map::DEFAULT_WIDTH}x#{Map::DEFAULT_HEIGHT}")
      link.should include("key=#{key}")
    end
    
    it "should use StaticMap::KEY if defined" do
      key = "just a kes"
      StaticMap::KEY = key
      @map.key = nil
      @map.to_s.should include("key=#{key}")
    end
    
    it "should include center in image url if center set manually" do
      @map.center = [47, 11]
      @map.to_s.should include("center=47,11")
    end
    
    it "should include markers in map url" do
      marker1 = Marker.new(:position => [1,1])
      marker2 = Marker.new(:position => [2,2])
      @map.markers = [marker1, marker2]
      @map.to_s.should include("#{marker1.to_s}|#{marker2.to_s}")
      @map.to_s.should_not include("zoom=")
    end
    
    it "should not include markers if empty" do
      @map.to_s.should_not include("markers=")
    end
    
    it "should not include zoom level if no center provided" do
      @map.zoom = 10
      @map.to_s.should_not include("zoom=10")
    end
    
    it "should include zoom level if center and zoom level provided" do
      @map.zoom = 10
      @map.center = [47,11]
      @map.to_s.should include("zoom=10")
    end
    
    it "should not include span if no center provided" do
      @map.span = [7,7]
      @map.to_s.should_not include("span=7,7")
    end
    
    it "should include span if center provided" do
      @map.center = [47, 11]
      @map.span = [7,7]
      @map.to_s.should include("span=7,7")
    end
    
    it "should ignore zoom if span and center provided" do
      @map.zoom = 7
      @map.span = [7,7]
      @map.center = [47, 11]
      @map.to_s.should include("span=7,7")
      @map.to_s.should_not include("zoom=")
    end
    
    it "should overwrite center of the map to last marker having center flag" do
      @map.center = [0,0]
      @map.markers << Marker.new(:position => [1, 1], :use_as_center => true)
      @map.markers << Marker.new(:position => [2, 2], :use_as_center => true)
      @map.to_s.should include("center=2,2")
    end
  end
end