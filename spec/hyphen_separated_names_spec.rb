require 'spec_helper'

describe "interpretting element names that contain hyphens" do
  before(:each) do
    @proxy = Peachy::Proxy.new <<XML
<test-node>
  <first-child>Check meh.</first-child>
  <second-child record-label="Rough Trade">Check meh, too.</second-child>
  <third-child record-label="Rough Trade"><text-node>Check meh again.</text-node></third-child>
</test-node>
XML
  end

  it "should try to match a method to a node with hyphens" do
    @proxy.test_node.first_child.value.should == 'Check meh.'
  end

  it "should define a method for the element name" do
    @proxy.test_node
    @proxy.methods.map{|m| m.to_s}.should include('test_node')
  end

  it "should match a method to an attribute by pascal case" do
    @proxy.test_node.second_child.record_label.should == 'Rough Trade'
  end

  it "should define a method from pascal cased attribute name" do
    @proxy.test_node.second_child.record_label
    @proxy.test_node.second_child.methods.map{|m| m.to_s}.should include('record_label')
  end

  it "should define a method on a parent with attributes" do
    @proxy.test_node.third_child.record_label.should == 'Rough Trade'
    @proxy.test_node.third_child.methods.map{|m| m.to_s}.should include('record_label')
  end

  it "should allow child nodes to be selected after an attrbiute is selected on a parent node" do
    @proxy.test_node.third_child.record_label.should == 'Rough Trade'
    @proxy.test_node.third_child.text_node.value.should == 'Check meh again.'
  end
end

