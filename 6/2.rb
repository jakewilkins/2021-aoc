# frozen_string_literal: true

require_relative "./1"

class PartTwo < Puzzle
  state :fish_states, {}

  def parse_inputs
    debug "initial input: #{input}"
    self.fish_states = input.map(&:to_i).tally
  end

  def calculate
    time_period.times do |i|
      debug "tick = #{i} count = #{fish_states}"
      self.fish_states = fish_states.each_with_object({}) do |(fish, count), next_tick|
        debug "#{fish} => #{count} === #{next_tick}", level: 2

        if fish == 0
          next_tick[8] = count
          if next_tick[6]
            next_tick[6] = next_tick[6] + count
          else
            next_tick[6] = count
          end
        else
          next_fish = fish - 1

          if next_tick[next_fish]
            next_tick[next_fish] = next_tick[next_fish] + count
          else
            next_tick[fish - 1] = count.dup
          end
        end
      end
    end
  end

  def post_process
    puts "There are #{fish_states.values.sum} fish after #{time_period}"
  end

  def time_period
    256
  end
end

if $0 == __FILE__
  PartTwo.call
end
