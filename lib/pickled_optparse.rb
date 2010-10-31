require 'optparse'

# Add required switches to OptionParser
class OptionParser
  
  # An array of messages describing the missing any required switches
  attr_reader :missing_switches
  
  # Convenience method to test if we're missing any required switches
  def missing_switches?
    !@missing_switches.nil?
  end

  def make_switch(opts, block = nil)
    short, long, nolong, style, pattern, conv, not_pattern, not_conv, not_style = [], [], []
    ldesc, sdesc, desc, arg = [], [], []
    default_style = Switch::NoArgument
    default_pattern = nil
    klass = nil
    n, q, a = nil

    # Check for required switches
    required = opts.delete(:required)

    opts.each do |o|
      
      # argument class
      next if search(:atype, o) do |pat, c|
        klass = notwice(o, klass, 'type')
        if not_style and not_style != Switch::NoArgument
          not_pattern, not_conv = pat, c
        else
          default_pattern, conv = pat, c
        end
      end

      # directly specified pattern(any object possible to match)
      if (!(String === o || Symbol === o)) and o.respond_to?(:match)
        pattern = notwice(o, pattern, 'pattern')
        if pattern.respond_to?(:convert)
          conv = pattern.method(:convert).to_proc
        else
          conv = SPLAT_PROC
        end
        next
      end

      # anything others
      case o
        when Proc, Method
          block = notwice(o, block, 'block')
        when Array, Hash
          case pattern
            when CompletingHash
            when nil
              pattern = CompletingHash.new
              conv = pattern.method(:convert).to_proc if pattern.respond_to?(:convert)
            else
              raise ArgumentError, "argument pattern given twice"
          end
          o.each {|pat, *v| pattern[pat] = v.fetch(0) {pat}}
        when Module
          raise ArgumentError, "unsupported argument type: #{o}", ParseError.filter_backtrace(caller(4))
        when *ArgumentStyle.keys
          style = notwice(ArgumentStyle[o], style, 'style')
        when /^--no-([^\[\]=\s]*)(.+)?/
          q, a = $1, $2
          o = notwice(a ? Object : TrueClass, klass, 'type')
          not_pattern, not_conv = search(:atype, o) unless not_style
          not_style = (not_style || default_style).guess(arg = a) if a
          default_style = Switch::NoArgument
          default_pattern, conv = search(:atype, FalseClass) unless default_pattern
          ldesc << "--no-#{q}"
          long << 'no-' + (q = q.downcase)
          nolong << q
        when /^--\[no-\]([^\[\]=\s]*)(.+)?/
          q, a = $1, $2
          o = notwice(a ? Object : TrueClass, klass, 'type')
          if a
            default_style = default_style.guess(arg = a)
            default_pattern, conv = search(:atype, o) unless default_pattern
          end
          ldesc << "--[no-]#{q}"
          long << (o = q.downcase)
          not_pattern, not_conv = search(:atype, FalseClass) unless not_style
          not_style = Switch::NoArgument
          nolong << 'no-' + o
        when /^--([^\[\]=\s]*)(.+)?/
          q, a = $1, $2
          if a
            o = notwice(NilClass, klass, 'type')
            default_style = default_style.guess(arg = a)
            default_pattern, conv = search(:atype, o) unless default_pattern
          end
          ldesc << "--#{q}"
          long << (o = q.downcase)
        when /^-(\[\^?\]?(?:[^\\\]]|\\.)*\])(.+)?/
          q, a = $1, $2
          o = notwice(Object, klass, 'type')
          if a
            default_style = default_style.guess(arg = a)
            default_pattern, conv = search(:atype, o) unless default_pattern
          end
          sdesc << "-#{q}"
          short << Regexp.new(q)
        when /^-(.)(.+)?/
          q, a = $1, $2
          if a
            o = notwice(NilClass, klass, 'type')
            default_style = default_style.guess(arg = a)
            default_pattern, conv = search(:atype, o) unless default_pattern
          end
          sdesc << "-#{q}"
          short << q
        when /^=/
          style = notwice(default_style.guess(arg = o), style, 'style')
          default_pattern, conv = search(:atype, Object) unless default_pattern
        else
          desc.push(o)
      end
    
    end
    
    default_pattern, conv = search(:atype, default_style.pattern) unless default_pattern
    if !(short.empty? and long.empty?)
      s = (style || default_style).new(pattern || default_pattern, conv, sdesc, ldesc, arg, desc, block)
    elsif !block
      if style or pattern
        raise ArgumentError, "no switch given", ParseError.filter_backtrace(caller)
      end
      s = desc
    else
      short << pattern
      s = (style || default_style).new(pattern, conv, nil, nil, arg, desc, block)
    end

    # Make sure required switches are given
    if required && !(default_argv.include?("-#{short[0]}") || default_argv.include?("--#{long[0]}"))
        @missing_switches ||= [] # Should be placed in initialize if incorporated into Ruby proper
        
        # This is ugly, long, and not very DRY but it's easy to understand
        #missing = "-#{short[0]}" if !short.empty?
        #missing = "#{missing} or " if !short.empty? && !long.empty?
        #missing = "#{missing}--#{long[0]}" if !long.empty?
        
        # This is even uglier and really hard to read but it is shorter and DRY'er
        missing = "#{"-#{short[0]}" if !short.empty?}#{" or " if !short.empty? && !long.empty?}#{"--#{long[0]}" if !long.empty?}"
         
        @missing_switches << "Missing switch: #{missing}"
    end
    
    return s, short, long,
      (not_style.new(not_pattern, not_conv, sdesc, ldesc, nil, desc, block) if not_style),
      nolong
  end
  
end
