require 'optparse'

# Add the ability to specify switches as required to OptionParser
class OptionParser
  
  # An array of messages describing any missing required switches
  attr_reader :missing_switches
  
  # Convenience method to test if we're missing any required switches
  def missing_switches?
    !@missing_switches.nil?
  end

  # Alias the OptionParser::make_switch function 
  # (instead of directly modifying it like I did in 0.1.0)
  alias :pickled_make_switch :make_switch
  
  # Wrapper for OptionParser::make_switch to allow for required switches
  def make_switch(opts, block = nil)
  
    # Test if a switch is required
    required = opts.delete(:required)

    return_values = pickled_make_switch(opts, block)

    # Make sure required switches are given
    if required 
      short = return_values[1][0].nil? ? nil : "-#{return_values[1][0]}"
      long = return_values[2][0].nil? ? nil : "--#{return_values[2][0]}"
      
      if !(default_argv.include?(short) || default_argv.include?(long))
        @missing_switches ||= [] # Should be placed in initialize if incorporated into Ruby proper
      
        # Ugly and hard to read, should figure out a prettier way of doing this
        @missing_switches << "Missing switch: #{short if !short.nil?}#{" or " if !short.nil? && !long.nil?}#{long if !long.nil?}"
      end
    end
    
    return return_values
  end
  
end
