require 'spec_helper'

describe "using a Mimic" do
  before(:each) do
    @mimic = Object.new
    class << @mimic
      include Peachy::Mimic
    end
  end

  it "should raise an error if the mimic method has not been overridden" do
    lambda { @mimic.mimic }.should raise_error(NothingToMimic)
  end
  
  it "should call the underlying object" do
    to_mimic = "Hello"
    @mimic.instance_eval do
      (class << self; self; end).instance_eval { define_method(:mimic) { to_mimic } }
    end
    
    @mimic.chomp('o').should == "Hell"
    @mimic.rjust(8).should == "   Hello"
  end
end