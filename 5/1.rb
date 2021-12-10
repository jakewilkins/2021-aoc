# frozen_string_literal: true

require_relative "../toolkit"

module Line
  def draw(point_one, point_two)
  end
end

class Point
  attr_reader :coordinates

  def initialize(*coordinates)
    @coordinates = coordinates.map(&:to_i)
  end

  def x
    coordinates.first
  end

  def y
    coordinates[1]
  end

  def -(other)
    [x - other.x, y - other.y]
  end

  def diagonal?(other)
    straight_x = x == other.x
    straight_y = y == other.y

    if straight_x || straight_y
      false
    else
      true
    end
  end

  def &(other)
    xdiff, ydiff = self - other
    increments = [xdiff.abs, ydiff.abs].max
    xincr = xdiff > 0 ? -1 : 1
    yincr = ydiff > 0 ? -1 : 1
    debug "Calculating points to fill line from #{self} to #{other}, xincr=#{xincr}, yincr=#{yincr}"
    points = [self]
    last = self
    nextx = x
    nexty = y

    increments.times do
      nextx += xincr if last.x != other.x
      nexty += yincr if last.y != other.y
      points << Point.new(nextx.abs, nexty.abs)
    end

    points
  end

  def hash
    "#{x}#{y}".hash
  end

  def to_s
    "(#{x},#{y})"
  end

  def ==(other)
    eql?(other)
  end

  def eql?(other)
    x == other.x && y == other.y
  end
end

class PartOne < Puzzle
  state :points, []
  state :doubles, []

  LINE_REGEX = %r|^(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)$|

  def parse_inputs
    input.each do |line|
      captures = LINE_REGEX.match(line)
      one = Point.new(captures[:x1], captures[:y1])
      two = Point.new(captures[:x2], captures[:y2])

      if one.diagonal?(two)
        pryd(:explore, binding)
        next
      end

      this_line = one & two
      points.concat(this_line)
      pryd(:explore, binding)
    end
  end

  def calculate
    tally = points.tally
    self.doubles = tally.values.select {|int| int != 1}.count
    pryd(:calc, binding)
  end

  def post_process
    puts "There are #{doubles} overlapping points."
  end
end

if $0 == __FILE__
  PartOne.call
end
