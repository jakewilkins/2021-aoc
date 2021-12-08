# frozen_string_literal: true

require_relative "../toolkit"

def calculate_column_criteria(index, input, desired:)
  intermediate = input.map {|bit| bit[index].to_i}
  counts = intermediate.tally.sort_by {|(k, v)| v}
  # count = intermediate.sum
  # half = input.count / 2

  if counts.first.last == counts.last.last
    if desired == 1
      "1"
    else
      "0"
    end
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
    debug "determined filtered at index #{index} -- #{filtered.first}"
    filtered
  else
    debug "filtered #{filtered.count}, filtering again"
    filter(filtered, desired: desired, index: index + 1)
  end
end

#o2g = filter(input, desired: 1).first.to_i(2)
debug!
co2 = filter(input, desired: 0).first.to_i(2)

#puts "o2g => #{o2g}"
puts "co2 => #{co2}"

#puts o2g * co2

