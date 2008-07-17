require File.dirname(__FILE__) + '/../spec_helper'
include StaticMap

describe Marker do
  it "should be initializable with options" do
    value =" just value"
    for key in %w{character color size use_as_center}
      marker = Marker.new(key.to_sym => value, :position => [1, 2])
      marker.send(key).should == value
    end
  end
  
  it "should return marker string on to_s" do
    Marker.new(:position => [1,1]).to_s.should == "1,1"
    Marker.new(:position => [1,1], :character => "c").to_s.should == "1,1"
    Marker.new(:position => [1,1], :size => "tiny").to_s.should == "1,1"
    Marker.new(:position => [1,1], :character => "c", :size => "tiny").to_s.should == "1,1"
    Marker.new(:position => [1,1], :character => "c", :size => "tiny", :color => "red").to_s.should == "1,1,tinyredc"
    Marker.new(:position => [1,1], :size => "tiny", :color => "red").to_s.should == "1,1,tinyred"
    Marker.new(:position => [1,1], :character => "c", :color => "red").to_s.should == "1,1,redc"
  end
  
  it "should throw an error when initializing withoiut position" do
    lambda {
      Marker.new 
    }.should raise_error(Marker::NoPositionSuppliedError)
  end
  
  it "should set position" do
    marker = Marker.new(:position => [1, 2])
    new_position = position = [2, 3]
    marker.position = new_position
    marker.position.should == new_position
  end
  
  it "should throw an erro when setting position to nil" do
    marker = Marker.new(:position => [1, 2])
    lambda {
      marker.position = nil
    }.should raise_error(Marker::NoPositionSuppliedError)
  end
end