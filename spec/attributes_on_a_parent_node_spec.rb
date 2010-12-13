require 'spec_helper'

describe "attributes on a parent node" do
  before(:each) do
    @proxy = Peachy::Proxy.new '<root><test_node name="Test"><child>Check meh.</child></test_node></root>'
  end

  it "should return the child when accessing it by name" do
    @proxy.root.test_node.child.value.should == 'Check meh.'
  end

  it "should return the parent attribute by name" do
    @proxy.root.test_node.name.should == 'Test'
  end

  it "should define the attribute name as a method" do
    @proxy.root.test_node.name
    @proxy.root.test_node.methods.map{|m| m.to_sym}.should include(:name)
  end

  it "should raise an error if the attirbute does not exist" do
    lambda { @proxy.root.test_node.other }.should raise_error(NoMatchingXmlPart)
  end
end
