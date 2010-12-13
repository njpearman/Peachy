require 'spec_helper'

describe "interpreting element and attribute names that are defined in PascalCase" do
  before(:each) do
    @proxy = Peachy::Proxy.new <<XML
<Root>
  <TestNode>Check meh.</TestNode>
  <SecondNode Id="2" RecordLabel="Wall of Sound">Check meh, too.</SecondNode>
  <ThirdNode Id="2" RecordLabel="Wall of Sound"><Child>Check meh again.</Child></ThirdNode>
</Root>
XML
  end

  it "should match a method to an element by pascal case" do
    @proxy.root.test_node.value.should == 'Check meh.'
  end

  it "should define a method from a pascal cased element name" do
    @proxy.root.test_node.value.should == 'Check meh.'
    @proxy.root.methods.map{|m| m.to_s}.should include('test_node')
  end

  it "should match a method to an attribute by pascal case" do
    @proxy.root.second_node.record_label.should == "Wall of Sound"
  end

  it "should define a method from pascal cased attribute name" do
    @proxy.root.second_node.record_label
    @proxy.root.second_node.methods.map{|m| m.to_s}.should include('record_label')
  end

  it "should define a method on a parent with attributes" do
    @proxy.root.third_node.record_label.should == 'Wall of Sound'
    @proxy.root.third_node.methods.map{|m| m.to_s}.should include('record_label')
  end

  it "should allow child nodes to be selected after an attrbiute is selected on a parent node" do
    @proxy.root.third_node.record_label.should == 'Wall of Sound'
    @proxy.root.third_node.child.value.should == 'Check meh again.'
  end
end

