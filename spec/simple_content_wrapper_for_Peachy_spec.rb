require 'spec_helper'
describe "Peachy::SimpleContent wrapper for the contents of a simple XML element" do
  before(:each) do
    @node_name = 'parent_node'
    @content = Peachy::SimpleContent.new 'the value', @node_name
  end

  it "should return the expected content" do
    @content.value.should == 'the value'
  end

  it "should to_s in the expected way" do
    @content.to_s.should == 'the value'
  end

  it "should return the value from the index of 0" do
    @content[0].value.should == 'the value'
  end

  it "should make the name of the parent node available" do
    @content.node_name.should == @node_name
  end

  it "should raise an error if the SimpleContent is treated as an Array after being treated as SimpleContent" do
    @content.value
    lambda { @content[0].value }.should raise_error AlreadyASingleChild, <<MESSAGE
The 'parent_node' node has already been accessed as a single child, but you are now trying to use it as a collection.
Do not try to access Peachy::Proxies in a mixed manner in your implementation.
MESSAGE
  end

  it "should behave as other objects when a method does not exist" do
    lambda { @content.how_random }.should raise_error NoMethodError
  end

  it "should behave as other objects when a method with a parameter does not exist" do
    lambda { @content.how_random("Hello") }.should raise_error NoMethodError
  end

  it "should behave as other objects when a method with a block does not exist" do
    lambda { @content.how_random() { puts "Boo!" } }.should raise_error NoMethodError
  end
end

