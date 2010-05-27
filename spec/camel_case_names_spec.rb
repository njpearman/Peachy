require 'spec_helper'
describe "interpreting element and attribute names that are defined in camelCase" do
  before(:each) do
    @proxy = Peachy::Proxy.new <<XML
<root>
  <testNode>Check meh.</testNode>
  <secondNode id="2" recordLabel="Wall of Sound">Check meh, too.</secondNode>
  <thirdNode id="2" recordLabel="Wall of Sound"><child>Nested</child></thirdNode>
</root>
XML
  end

  it "should match a method to an element by camel case" do
    @proxy.root.test_node.value.should == 'Check meh.'
  end

  it "should define a method from a camel cased element name" do
    @proxy.root.test_node.value.should == 'Check meh.'
    @proxy.root.methods.should include('test_node')
  end

  it "should match a method to an attribute by camel case" do
    @proxy.root.second_node.record_label.should == "Wall of Sound"
  end

  it "should define a method from camel cased attribute name" do
    @proxy.root.second_node.record_label
    @proxy.root.second_node.methods.should include('record_label')
  end

  it "should match parent attribute names" do
    @proxy.root.third_node.record_label.should == 'Wall of Sound'
    @proxy.root.third_node.methods.should include('record_label')
  end
end

