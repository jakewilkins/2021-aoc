
def debug!
  $debug = true
end

def nebug!
  $debug = false
end

def debug(str)
  if $debug
    $stderr.puts str
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
