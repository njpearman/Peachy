describe "inferring a method from an attribute" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<test-node id="1" another="yellow">Check meh.</test-node>'
  end

  it "should be able to access node contents by 'value'" do
    @proxy.test_node.value.should == 'Check meh.'
  end

  it "should be able to generate a method representing an attribute" do
    @proxy.test_node.id.should == '1'
  end

  it "should raise an error if method name doesn't match an attribute name" do
    lambda { @proxy.test_node.missing }.should raise_error NoMatchingXmlPart, "missing is not contained as a child of this node."
  end
end

