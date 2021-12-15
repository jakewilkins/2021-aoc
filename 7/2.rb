# frozen_string_literal: true

require_relative "1"

class PartTwo < PartOne
  def calculate
    (smallest - 5).upto(biggest + 5) do |candidate_number|
      debug "Checking destination #{candidate_number}"
      mileages << crabs.map do |c|
        triangle((c - candidate_number).abs)
      end.sum
    end
    debug "mileages: #{mileages}", level: 2
  end

  def triangle(n)
    (n * (n + 1)) / 2
  end
end
