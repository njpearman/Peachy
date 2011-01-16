require 'spec_helper'

describe "Peachy::SimpleContent wrapper for the contents of a simple XML element" do
  before(:each) do
    @expected_to_s = "<blar>boo</blar>"
    mock_wrapper = mock()
    mock_wrapper.stubs(:name).returns('real_node')
    mock_wrapper.stubs(:content).returns('the real value')
    mock_wrapper.stubs(:to_s).returns(@expected_to_s)
    @content = Peachy::SimpleContent.new mock_wrapper
  end

  it "should return the expected content" do
    @content.value.should == 'the real value'
  end

  it "should to_s in the expected way" do
    @content.to_s.should == @expected_to_s
  end

  it "should return the value from the index of 0" do
    item = @content[0]
    item.value.should == 'the real value'
  end

  it "should make the name of the parent node available" do
    @content.name.should == 'real_node'
  end

  it "should raise an error if the SimpleContent is treated as an Array after being treated as SimpleContent" do
    expected_message = <<MESSAGE
The 'real_node' node has already been accessed as a single child, but you are now trying to use it as a collection.
Do not try to access Peachy::Proxies in a mixed manner in your implementation.
MESSAGE
    @content.value
    lambda { @content[0].value }.should raise_error(AlreadyAnOnlyChild, expected_message)
  end

  it "should behave as other objects when a method does not exist" do
    lambda { @content.how_random }.should raise_error(NoMethodError)
  end

  it "should behave as other objects when a method with a parameter does not exist" do
    lambda { @content.how_random("Hello") }.should raise_error(NoMethodError)
  end

  it "should behave as other objects when a method with a block does not exist" do
    lambda { @content.how_random() { puts "Boo!" } }.should raise_error(NoMethodError)
  end
end

