#!/usr/bin/env ruby
require_relative '../lib/pickled_optparse'

# Configure options based on command line options
@options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  # Note that :required can be anywhere in the parameters
  
  # Also note that OptionParser is bugged and will only check 
  # for required parameters on the last option, not my bug.
   
  # required switch, required parameter
  opts.on("-s Short", String, :required, "a required switch with just a short") do |operation|
    @options[:operation] = operation
  end

  # required switch, optional parameter
  opts.on(:required, "--long [Long]", String, "a required switch with just a long") do |operation|
    @options[:operation] = operation
  end

  # required switch, required parameter
  opts.on("-b", "--both ShortAndLong", String, "a required switch with short and long", :required) do |operation|
    @options[:operation] = operation
  end

  # optional switch, optional parameter
  opts.on("-o", "--optional [Whatever]", String, "an optional switch with short and long") do |operation|
    @options[:operation] = operation
  end

  # Now we can see if there are any missing required 
  # switches so we can alert the user to what they 
  # missed and how to use the program properly.
  if opts.missing_switches?
    puts opts.missing_switches
    puts opts
    exit
  end

end.parse!

