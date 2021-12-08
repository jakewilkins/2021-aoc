
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

def prys_enabled=(arg)
  $prys_enabed = arg
end

def prys_enabled
  $prys_enabled
end

def pry_enabled?(name)
  $prys_enabled.include?(name)
end

def pry(named, bind = nil)
  if pry_enabled?(name)
    (bind || binding).pry
  end
end