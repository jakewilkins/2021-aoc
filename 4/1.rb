# frozen_string_literal: true

require_relative "../toolkit"
require "set"

class Board
  attr_reader :rows, :marked

  def initialize(rows)
    @rows = rows
    @marked = Set.new
  end

  def lines
    @lines ||= (rows + rows.transpose).map(&:to_set)
  end

  def mark(number)
    return if won?
    marked << number
  end

  def won?
    lines.any? {|line| line.subset?(marked)}
  end

  def score
    # sum of unmarked numbers
    rows.flat_map do |row|
      row.reject do |num|
        marked.include?(num)
      end.map(&:to_i)
    end.sum
  end

  def draw
    str = rows.map do |row|
      row.map do |num|
        s = num.to_s.rjust(2)
        s = s.colorize(:red) if marked.include?(num)
        s
      end.join(" ")
    end.join("\n")
    # debug str
    # debug "---"
  end
end

def read_next_board(lines)
  board = []
  line = lines.shift

  until (line == "" || line.nil?)
    board << line
    line = lines.shift
    debug "read line: #{line.inspect}", level: 3
  end
  board
end

def parse_board(lines)
  Board.new(lines.map { |l| l.split(" ")})
end

# debug!; debug!; debug!

def setup
  lines = input.split("\n")
  numbers = lines.shift.split(","); lines.shift
  debug "numbers: #{numbers.count}"

  boards = []

  while lines.count > 1
    debug "reading next board!"
    board_lines = read_next_board(lines)
    boards << parse_board(board_lines) unless board_lines.empty?
  end

  [numbers, boards]
end

numbers, boards = setup

if $0 == __FILE__
  # enable_pry :start

  board, winning_number = numbers.each do |number|
    boards.each { |board| board.mark(number) }

    winner = boards.find { |board| board.won? }

    if winner
      break [winner, number.to_i]
    end
  end

  pryd(:start, binding)

  puts "--------------"
  puts board.draw
  puts "--------------"

  puts "Board score: #{board.score.inspect}"
  puts "Winning number: #{winning_number.inspect}"
  puts "Answer: #{board.score * winning_number}"
end
