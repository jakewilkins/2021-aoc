# frozen_string_literal: true

require_relative "../toolkit"

module Line
  def draw(point_one, point_two)
  end
end

class Point
  attr_reader :coordinates

  def initialize(*coordinates)
    @coordinates = coordinates
  end
end

class PartOne < Puzzle
  state :points, []
  state :doubles, []

  LINE_REGEX = %r|^(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)$|

  def parse_inputs
    input.each do |line|
      captures = LINE_REGEX.match(line)
      pryd(:explore, binding)
    end
  end
end

if $0 == __FILE__
  PartOne.call
end
