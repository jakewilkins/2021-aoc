#!/usr/bin/env ruby

load "./1-input.rb"

count = 0
INPUT.length.times do |i|
    this, nxt = INPUT[i], INPUT[i + 1]
    next if !(this && nxt)
    count += 1 if this < nxt
end

puts count