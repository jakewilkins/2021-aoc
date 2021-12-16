# frozen_string_literal: true

require_relative "../toolkit"

class PartOne < Puzzle
  state :displays, []
  state :calculated_value, 0

  Display = Struct.new(:all_possibilities, :scrambled_values, :value, :original_value)

  DISTINCT_NUMBER_SEGMENTS = {
    # number display => number of segments used
    1 => 2,
    4 => 4,
    7 => 3,
    8 => 7
  }

  def parse_inputs
    self.displays = input.map do |line|
      observations, displayed = line.split(" | ")
      Display.new(observations.split(" "), displayed.split(" ").map {|s| s.chars.sort.join})
    end
  end

  def calculate
    displays.each do |display|
      known_digits = recognize_known_digits(display.all_possibilities)
      display.original_value = display.scrambled_values
      replace_known_values(known_digits, display)

      if display.scrambled_values.all?(Integer)
        display.value = display.scrambled_values.join.to_i
        next
      end

      replace_unkown_values(known_digits, display)

      display.value = display.scrambled_values.join.to_i
      pryd(:e, binding)
    end
  end

  def post_process
    debug(level: 1) { displays.map(&:value).to_s }
    self.calculated_value = displays.map(&:value).sum
    puts "The sum of all displays is #{calculated_value}"
  end

  # def resolve_number

  def replace_known_values(known_digits, display)
    debug(level: 2) { display.scrambled_values.to_s }
    display.scrambled_values = display.scrambled_values.map do |value|
      found_value = known_digits.key(value) || value
      debug(level: 3) { "value = #{value}, known_values = #{known_digits}, found_value = #{found_value}" }
      found_value
    end
    debug(level: 2) { display.scrambled_values.to_s }
  end

  def replace_unkown_values(known_values, display)
    known_values = known_values.map {|k, v| [k, v.chars]}.to_h
    display.scrambled_values = display.scrambled_values.map do |value|
      next value unless value.is_a?(String)
      find_numeric(known_values, value)
    end
  end

  # Looks for:
  #   0, 2, 3, 5, 6, 9
  def find_numeric(known_values, value)
    possibilities = value.length == 6 ? [0, 6, 9] : [2, 3, 5]
    possibilities.find {|number| send(:"is_#{number}?", value.chars, known_values)}
  end

  def is_0?(value, known_values)
    pryd(:z, binding)
    (value & known_values[4]).empty?
  end

  def is_2?(value, known_values)
    return false if is_3?(value, known_values)
    !is_5?(value, known_values)
  end

  def is_3?(value, known_values)
    pryd(:three, binding)
    (known_values[1] - value).empty?
  end

  def is_5?(value, known_values)
    pryd(:five, binding) if value == %w|b c d e f|
    !is_3?(value, known_values) && (value - known_values[4]).length == 2
  end

  def is_6?(value, known_values)
    return false if is_0?(value, known_values)
    (value & known_values[7]).length == 2
  end

  def is_9?(value, known_values)
    return false if is_0?(value, known_values)
    !is_6?(value, known_values)
  end

  def recognize_known_digits(displayed)
    DISTINCT_NUMBER_SEGMENTS.each_with_object({}) do |(number, segments), out|
      out[number] = displayed.find {|d| d.length == segments}.chars.sort.join
    end
  end
end
