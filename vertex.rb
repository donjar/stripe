# frozen_string_literal: true

class Vertex
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def distance_to(other)
    Math.sqrt((@x - other.x)**2 + (@y - other.y)**2)
  end

  def hash
    [@x, @y].hash
  end

  def eql?(other)
    self == other
  end
end
