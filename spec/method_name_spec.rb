require 'spec_helper'

describe "how to use Peachy::MethodName" do
  before(:each) do
    @method_name = Peachy::MethodName.new 'method_name'
  end

  it "should return the original string as to_s" do
    @method_name.to_s.should == "method_name"
  end

  it "should return the expected symbol as to_sym" do
    @method_name.to_sym.should == :method_name
  end

  it "should return the expected number of variations in format" do
    @method_name.variations.size.should == 4
  end

  it "should return the expected variation formats" do
    variations = @method_name.variations

    variations.should include('method_name')
    variations.should include('methodName')
    variations.should include('method-name')
    variations.should include('MethodName')
  end

  it "should be possible to create a MethodName from a symbol" do
    @method_name = Peachy::MethodName.new :this_method
    variations = @method_name.variations

    @method_name.to_s.should == 'this_method'
    @method_name.to_sym.should == :this_method
    
    variations.should include('this_method')
    variations.should include('thisMethod')
    variations.should include('this-method')
    variations.should include('ThisMethod')
  end

  it "should not include duplicates in variations" do
    @method_name = Peachy::MethodName.new :method
    variations = @method_name.variations

    variations.size.should == 2
    variations.should include('method')
    variations.should include('Method')
  end

  it "should know how to check for convention" do
    @method_name = Peachy::MethodName.new('method_name')
    @method_name.matches_convention?.should be_true
  end

  it "should know when a method name does not match the accepted convention" do
    method_name = Peachy::MethodName.new('method_Name')
    method_name.matches_convention?.should be_false
  end
end