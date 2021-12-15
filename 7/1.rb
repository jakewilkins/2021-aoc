# frozen_string_literal: true

require_relative "../toolkit"

class PartOne < Puzzle
  state :crabs, []
  state :mean, 0
  state :mode, 0
  state :mileages, []

  def parse_inputs
    self.crabs = input.map(&:to_i).sort
    tally = crabs.tally
    self.mode = crabs[tally.values.sort.last]
    self.mean = crabs.sum / crabs.length
  end

  def calculate
    smallest.upto(biggest) do |candidate_number|
      mileages << crabs.map {|c| (c - candidate_number).abs }.sum
    end
    pryd(:explore, binding)
  end

  def post_process
    puts "The shortest distance is #{mileages.sort.first}."
  end

  def smallest
    [mode, mean].min
  end

  def biggest
    [mode, mean].max
  end
end


