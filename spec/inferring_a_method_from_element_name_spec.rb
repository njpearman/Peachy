require 'spec_helper'
describe "inferring a method from an element name" do
  before(:each) do
    xml = '<testnode>Check meh.</testnode>'
    @proxy = Peachy::Proxy.new xml
    @another_proxy = Peachy::Proxy.new xml
  end

  it "should defer method_missing to the base class implementation if arguments are passed with the missing method" do
    lambda { @proxy.my_call "argument" }.should raise_error(NoMethodError)
  end

  it "should defer method_missing to the base class implementation if block is given with method_missing" do
    lambda { @proxy.my_call() { puts "Blockhead." } }.should raise_error(NoMethodError)
  end

  it "should not expose the original method_missing alias publically" do
    @proxy.methods.map{|m| m.to_s}.include?('original_method_missing').should be_false
  end

  it 'should add a reader for the method to the underlying class if the method does map to underlying XML node' do
    @proxy.testnode
    @proxy.methods.map{|m| m.to_s}.include?('testnode').should be_true
  end

  it 'should define the method on an instance, not on the class' do
    @proxy.testnode
    @proxy.methods.map{|m| m.to_s}.should include('testnode')
    @another_proxy.methods.map{|m| m.to_s}.should_not include('testnode')
  end

  it "should return the node contents when the node isn't defined as a method and the contents of the node is at the lowest point of the tree" do
    @proxy.testnode.value.should == 'Check meh.'
  end

  it "should define a method that returns the node contents is at the lowest point of the tree" do
    contents_when_not_defined = @proxy.testnode.value
    contents_after_defined = @proxy.testnode.value
    contents_after_defined.should == 'Check meh.'
    contents_after_defined.should == contents_when_not_defined
  end

  it "should only contain the expected public and protected methods" do
    all_methods = @proxy.methods.map{|m| m.to_s}
    all_methods.should include('inspect')
    all_methods.should include('methods')
    all_methods.should include('nil?')
    all_methods.should include('respond_to?')
    all_methods.should include('to_s')
    all_methods.should include('instance_eval')
    all_methods.should include('kind_of?')
    all_methods.should include('send')
    all_methods.should include('is_a?')
    all_methods.should_not include('id')
  end
end
