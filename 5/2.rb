# frozen_string_literal: true

require_relative "1"

class Point
  def diagonal?(_); false; end
end

PartTwo = PartOne

if $0 == __FILE__
  PartTwo.call
end
