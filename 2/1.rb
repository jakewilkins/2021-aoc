# frozen_string_literal: true

require_relative "./input.rb"

COMMANDS = {
    "up" => -> (position, change) { position[0] = position[0] - change; position },
    "down" => -> (position, change) { position[0] = position[0] + change; position },
    "forward" => -> (position, change) { position[1] = position[1] + change; position},
}

depth = 0
horizontal = 0
position = [depth, horizontal]
INPUT.each do |command|
    command, change = command.split(" ")
    position = COMMANDS[command].call(position, change.to_i)
end
p position
puts position[0] * position[1]