# frozen_string_literal: true

require_relative "../toolkit"

class PartOne < Puzzle
  state :fish_states, []

  def parse_inputs
    self.fish_states = input.map(&:to_i)
  end

  def calculate
    time_period.times do |i|
      debug "tick = #{i} count = #{fish_states.count}"
      self.fish_states = fish_states.flat_map do |i|
        if i == 0
          [6, 8]
        else
          i - 1
        end
      end
    end
  end

  def time_period
    80
  end

  def post_process
    puts "There are #{fish_states.count} fish after #{time_period}"
  end
end

# debug!

if $0 == __FILE__
  PartOne.call
end
