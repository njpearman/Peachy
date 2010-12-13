require 'spec_helper'

describe "inferring a method from an attribute" do
  before(:each) do
    @proxy = Peachy::Proxy.new '<test-node id="1" another="yellow">Check meh.</test-node>'
  end

  it "should be able to access node contents by 'value'" do
    @proxy.test_node.value.should == 'Check meh.'
  end

  it "should be able to generate a method representing an attribute" do
    @proxy.test_node.id.should == '1'
  end

  it "should define a method for the attribute name" do
    @proxy.test_node.another
    @proxy.test_node.methods.map{|m| m.to_s}.should include('another')
  end

  it "should raise an error if method name doesn't match an attribute name" do
    lambda { @proxy.test_node.missing }.should raise_error(NoMatchingXmlPart, "missing is not contained as a child of the node test-node.")
  end
end

