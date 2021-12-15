# frozen_string_literal: true

require_relative "../toolkit"

class PartOne < Puzzle
  state :displays, []
  state :known_digits, 0

  DISTINCT_NUMBER_SEGMENTS = {
    # number displace => number of segments used
    1 => 2,
    4 => 4,
    7 => 3,
    8 => 7
  }

  def parse_inputs
    self.displays = input.map do |line|
      observations, displayed = line.split(" | ")
      {obs: observations.split(" "), disp: displayed.split(" ")}
    end
  end

  def calculate
    displays.each do |h|
      self.known_digits += recognize_known_digits(h[:disp]).count
    end
  end

  def post_process
    puts "There were #{known_digits} known digits displayed."
  end

  def recognize_known_digits(displayed)
    displayed.select {|d| DISTINCT_NUMBER_SEGMENTS.values.include?(d.length)}
  end
end
