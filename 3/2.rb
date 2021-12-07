# frozen_string_literal: true

require_relative "input.rb"

sums = [0, 0,0,0,0,0,0,0, 0, 0, 0, 0]

INPUT.each do |string|
  string.chars.each_with_index do |char, index|
    sums[index] += char.to_i
  end
end

count = INPUT.count
half = count / 2

p sums
p count
p half

o2_criteria = sums.map do |bit|
  puts "= #{bit}" if bit == half
  bit > half ? 1 : 0
end.join

co2_criteria = sums.map do |bit|
  puts "= #{bit}" if bit == half
  bit < half ? 1 : 0
end.join

def filter(input, criteria, index = 0)
  filtered = input.select do |entry|
    entry[index] == criteria[index]
  end

  if filtered.length < 2
    puts "determined filtered #{criteria} at index #{index} -- #{filtered.first}"
    filtered
  else
    filter(filtered, criteria, index + 1)
  end
end


o2g = filter(INPUT, o2_criteria).first
co2 = filter(INPUT, co2_criteria).first

puts o2g.to_i(2) * co2.to_i(2)

# require "pry"; binding.pry
