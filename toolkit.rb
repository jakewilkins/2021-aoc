# frozen_string_literal: true

require "bundler"
Bundler.setup

require "optparse"

require "tty-progressbar"
require "colorize"
require "diffy"
# require "parser/current"

PRYS_ENABLED = []

module Helpers
  def debug!
    $debug ||= 0
    $debug += 1
  end

  def nebug!
    $debug ||= 0
    $debug -= 1
  end

  def debug(str = nil, level: 1, output: true, &block)
    $debug ||= 0
    if $debug >= level
      value = str || block.call
      if output
        $stderr.puts value
      else
        value
      end
    end
  end

  def example_run?
    ENV.key?('EXAMPLE')
  end

  def running_script
    File.expand_path($0)
  end

  def challenge_day
    File.basename(File.dirname(running_script))
  end

  def input_file_path
    File.expand_path("#{challenge_day}/input.rb")
  end

  def load_input!
    return if $input_loaded
    load input_file_path
    $input_loaded = true
  end

  def input
    load_input!
    if example_run?
      EXAMPLE_INPUT
    else
      INPUT
    end
  end

  def enable_pry(arg)
    PRYS_ENABLED << arg
  end

  def prys_enabled
    if ENV.key?('PRY')
      ::PRYS_ENABLED.concat(ENV['PRY'].split(',').map(&:intern)).uniq!
      PRYS_ENABLED
    else
      ::PRYS_ENABLED
    end
  end

  def pry_enabled?(name)
    if prys_enabled.include?(name)
      require "pry"
      return true
    end
    false
  end

  def pryd(named, bind = nil)
    if pry_enabled?(named)
      bind.pry
    end
  end
end

extend Helpers
include Helpers

class Puzzle
  include Helpers

  def self.puzzled?
    @puzzled
  end

  def self.puzzled!
    @puzzled = true
  end

  def self.children
    @children ||= []
  end

  def self.puzzle_class
    Puzzle.children.last
  end

  def self.state_defaults(state = nil)
    return @state if defined?(@state) && !state

    @state = if state
      (@state || {}).merge(state)
    else
      {}
    end
  end

  def self.state(name, default)
    attr_accessor name
    state_defaults[name] = default
  end

  def self.call
    new.call
  end

  def self.inherited(other)
    children << other

    def other.inherited(so)
      so.state_defaults(state_defaults)
      Puzzle.children << so
    end
  end

  def initialize(**args)
    self.class.state_defaults.each do |key, default|
      instance_variable_set(:"@#{key}", args[key] || default.clone)
    end
  end

  def call
    self.class.puzzled!
    parse_inputs
    debug(level: 3) { "starting state: #{state}" }
    calculate
    post_process
  end

  def parse_inputs
    input
  end

  def calculate
    raise NotImplementedError
  end

  def post_process
    puts "done"
  end

  def state
    self.class.state_defaults.keys.each_with_object({}) do |attr, out|
      out[attr] = self.send(attr)
    end
  end

  def to_s
    attrs = state.each_with_object([]) do |(k, v), out|
      out << "#{k}=#{v}"
    end

    "<#{self.class.name}: #{attrs.join(", ")}"
  end
end

module ARGS
  PARSER = -> () { OptionParser.new do |opts|
    opts.banner = "Usage: coverage [options]"

    opts.on("-pPRY", "--pry=PRY", "The pry sessions to enable") do |s|
      ::PRYS_ENABLED.concat(s.split(',').map(&:intern))
    end

    opts.on("-d", "--debug", "Increase the debug level") do
      debug!
    end

    opts.on("-e", "--[no-]example", "Use the example input for this run") do |v|
      if v
        ENV['EXAMPLE'] = '1'
      end
    end

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end }

  PARSER_HELP = PARSER.call.to_s

  def self.parse!
    args = ARGV.dup
    PARSER.call().parse!(ARGV)
    debug(level: 2) { "Parsed args #{args}" }
  end
end
ARGS.parse!


at_exit {
  unless Puzzle.puzzled?
    debug "Running #{Puzzle.puzzle_class}"
    Puzzle.puzzle_class.call
  end
}
