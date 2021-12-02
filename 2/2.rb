# frozen_string_literal: true

require_relative "./input.rb"

module Commands
  module_function

  DEPTH = 0
  HORIZONTAL = 1
  AIM = 2

  def apply(command, position:, change:)
    case command
    when "up"
      update_index(position, AIM, -change)
    when "down"
      update_index(position, AIM, change)
    when "forward"
      position = update_index(position, HORIZONTAL, change)
      update_index(position, DEPTH, change * position[AIM])
    end
  end

  def update_index(position, index, change)
    position[index] = position[index] + change
    position
  end

end

position = [0, 0, 0]

INPUT.each do |command|
  command, change = command.split(" ")
  position = Commands.apply(command, position: position, change: change.to_i)
end

p position

puts position[0] * position[1]
