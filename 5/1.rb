# frozen_string_literal: true

require_relative "../toolkit"

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
