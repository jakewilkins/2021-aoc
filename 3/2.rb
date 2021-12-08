# frozen_string_literal: true

require_relative "../toolkit"

def calculate_column_criteria(index, input, desired:)
  intermediate = input.map {|bit| bit[index].to_i}
  debug intermediate.join, level: 3
  counts = intermediate.tally.sort_by {|(k, v)| v}
  debug counts.inspect, level: 3
  # count = intermediate.sum
  # half = input.count / 2

  if counts.first.last == counts.last.last
    debug "counts are equal, returning on #{desired}", level: 2
    return desired.to_s
  end

  if desired == 1
    counts.last.first.to_s
    # count >= half ? "1" : "0"

  else
    counts.first.first.to_s
    # count >= half ? "0" : "1"
  end
end

def filter(input, desired:, index: 0)
  criteria = calculate_column_criteria(index, input, desired: desired)

  filtered = input.select do |entry|
    entry[index] == criteria
  end

  if filtered.length < 2
    debug "determined filtered at index #{index} -- #{filtered.first} last filter: #{criteria}"
    filtered
  else
    debug "filtered for #{criteria} -- #{filtered.count}, filtering again #{debug(filtered, level: 3, output: false)}"
    filter(filtered, desired: desired, index: index + 1)
  end
end

o2g = filter(input, desired: 1).first.to_i(2)
co2 = filter(input, desired: 0).first.to_i(2)

puts "o2g => #{o2g}"
puts "co2 => #{co2}"

puts o2g * co2

