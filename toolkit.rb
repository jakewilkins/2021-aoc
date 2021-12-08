# frozen_string_literal: true

require "bundler"
Bundler.setup
require "tty-progressbar"
require "colorize"
require "diffy"
require "parser/current"

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

  def debug(str, level: 1, output: true)
    $debug ||= 0
    if $debug >= level
      if output
        $stderr.puts str
      else
        str
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

class Puzzle
  include Helpers

  def self.state_defaults(state = nil)
    return @state if defined?(@state)
    @state = {}
  end

  def self.state(name, default)
    attr_reader name
    state_defaults[name] = default
  end

  def self.call
    new.call
  end

  def initialize(**args)
    self.class.state_defaults.each do |key, default|
      instance_variable_set(:"@#{key}", args[key] || default.clone)
    end
  end

  def call
    parse_inputs
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
end
