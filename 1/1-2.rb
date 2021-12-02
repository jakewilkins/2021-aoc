
load "./1-input.rb"

count = 0
INPUT.length.times do |i|
    window_sum = INPUT.slice(i, 3).sum
    next_window_sum = INPUT.slice(i + 1, 3).sum
    next if !(window_sum && next_window_sum)
    count += 1 if window_sum < next_window_sum
end

puts count
