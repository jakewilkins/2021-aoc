# frozen_string_literal: true

require_relative "../toolkit"

class PuzzleOne < Puzzle
  state :rows, []
  state :columns, []
  state :point_values, []
  state :debug_display, ""
  state :column_count, 0
  state :row_count, 0

  def parse_inputs
    self.rows         = input.map {|row| row.chars.map(&:to_i)}
    self.columns      = rows.transpose
    self.column_count = columns.count
    self.row_count    = rows.count

    debug(output: false) { self.debug_display = rows.map {|r| r.map(&:to_s)} }

    # debug input
  end

  def calculate
    row_count.times do |row|
      column_count.times do |column|
        point_value     = rows[row][column]
        lowest_neighbor = neighbors(row, column).sort.first

        if point_value < lowest_neighbor
          debug "Selecting point (#{row}, #{column}) - #{point_value}", level: 2
          debug(output: false) do
            debug_display[row][column] = point_value.to_s.red
          end
          point_values << point_value + 1
        end
      end
    end
  end

  def post_process
    debug "There are #{point_values.count} low points."
    sum = point_values.sum
    debug "#{point_values.join(" + ")} = #{sum}"
    debug { puts debug_display.map {|r| r.join}.flatten.join("\n") }
    puts "The answer is #{sum}"
  end

  def neighbors(row, column)
    debug "fetching neighbors for #{row}, #{column}"
    neighbors = []
    if column > 0
      neighbors << rows[row][column - 1]
      debug "Column > 0, adding lower neighbor <#{neighbors}", level: 4
    end
    if (column + 1)  < column_count
      neighbors << rows[row][column + 1]
      debug "Column < #{column_count}, adding lower neighbor <#{neighbors}", level: 4
    end
    if row > 0
      neighbors << columns[column][row - 1]
      debug "Column > 0, adding lower neighbor <#{neighbors}", level: 4
    end

    if (row + 1) < row_count
      neighbors << columns[column][row + 1]
      debug "Column < #{row_count}, adding lower neighbor column: #{columns[column]}, row: #{row}#{neighbors}", level: 4
    end

    if neighbors.include?(nil)
      debug "row: #{row}, column: #{column}, row: #{row - 1}, row_count: #{row_count}", level: 3
      debug columns[column].inspect, level: 3
    end
    pryd(:n, binding)
    debug neighbors.inspect, level: 2
    neighbors
  end
end
