require_relative '../spec_helper'

describe "Pickled OptionParse" do

  before do
    @op = OptionParser.new
  end
  
  describe "added properites" do
    it "should have a missing_switches? parameter to indicate there are missing ones" do
      @op.should respond_to(:missing_switches?)
    end 
    
    it "should have a missing_switches parameter to describe the missing switches" do
      @op.should respond_to(:missing_switches)
    end
  end # added properites

  describe "no required switches missing" do
  
    it "should not have :missing_switches? set to true" do
      ARGV << "-r"
      op = OptionParser.new
      op.on("-r", "--required_switch", String, :required, "a required switch")
      op.parse!
      op.missing_switches?.should_not == true
    end

  end # no required switches missing

  describe "required switches are missing" do
    before do
      @op.on("-r", "--required_switch", String, :required, "a required switch")
      @op.on("-s pickle_type", String, :required, "a required switch")
      @op.on("--third_required_switch [blah]", String, :required, "a required switch")
      @op.parse!
    end
    
    it "should have :missing_switches? set to true" do
      @op.missing_switches?.should == true
    end
  
    it "should store information about the missing switches" do
      @op.missing_switches.to_s.downcase.should include('missing switch', 
                                                        '-r', '--required_switch', 
                                                        '-s', 
                                                        '--third_required_switch')
    end
    
  end # required switches are missing

end
