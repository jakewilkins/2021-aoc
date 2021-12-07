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

gamma_bin = sums.map do |bit|
  bit > half ? 1 : 0
end

epsilon_bin = sums.map do |bit|
  bit < half ? 1 : 0
end

puts gamma_bin.join
puts epsilon_bin.join

gamma = gamma_bin.join.to_i(2)
epsilon = epsilon_bin.join.to_i(2)

puts gamma * epsilon
