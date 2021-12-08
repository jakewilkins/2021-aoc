# frozen_string_literal: true

require_relative "../toolkit"
require_relative "1"

numbers, boards = setup

if $0 == __FILE__
  winners = Set.new

  numbers.each do |number|
    boards.each { |board| board.mark(number) }

    winner = boards.find { |board| board.won? }

    if winner
      boards.delete(winner)
      winners << [winner, number.to_i]
    end

    if boards.all? { |board| board.won? }
      break
    end
  end

  board, winning_number = winners.to_a.last
  pryd(:start, binding)

  puts "--------------"
  puts board.draw
  puts "--------------"

  puts "Board score: #{board.score.inspect}"
  puts "Winning number: #{winning_number.inspect}"
  puts "Answer: #{board.score * winning_number}"
end
