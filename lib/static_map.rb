$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module StaticMap
  class Map
    BASE_URL = "http://maps.google.com/staticmap?"
    DEFAULT_WIDTH = 200
    DEFAULT_HEIGHT = 200
    
    attr_accessor :markers, :center, :key, :zoom, :span, :width, :height, :maptype
    
    def initialize(ops = {})
      ops[:markers] ||= Array.new
      ops.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    
    def to_s
      key_to_use = self.key
      key_to_use ||= KEY if defined?(KEY)
      params = ["key=#{key_to_use}", "size=#{self.width || DEFAULT_WIDTH}x#{self.height || DEFAULT_HEIGHT}"]
      map_center = self.center
      for marker in self.markers
        map_center = marker.position if marker.use_as_center
      end
      if !map_center.nil?
        params << "center=#{map_center.join(",")}"
        if self.span.nil?
          params << "zoom=#{self.zoom}" if !self.zoom.nil?
        elsif 
          params << "span=#{self.span.join(",")}"
        end
      elsif !self.zoom.nil?
        params << "zoom=#{self.zoom}"
      end
      params << "maptype=#{self.maptype}" if !self.maptype.nil?
      params << "markers=#{self.markers.join("|")}" if !markers.empty?
      BASE_URL + params.join("&")
    end
  end
  
  class Marker
    class NoPositionSuppliedError < StandardError; end
    attr_accessor :position, :character, :size, :color, :use_as_center
    
    def initialize(ops = {})
      raise NoPositionSuppliedError if ops[:position].nil?
      ops.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    
    def position=(new_position)
      raise NoPositionSuppliedError if new_position.nil?
      @position = new_position
    end
    
    def to_s
      chunks = [self.position.first, self.position.last]
      style = ""
      style << size.to_s if !size.nil?
      if !color.nil?
        style << color
        style << character if !character.nil?
        chunks << style if style.length > 0
      end
      chunks.join(",")
    end
  end
end