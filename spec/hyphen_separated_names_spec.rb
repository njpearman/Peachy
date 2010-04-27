describe "interpretting element names that contain hyphens" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<test-node>Check meh.</test-node>'
  end

  it "should try to match a method to a node with hyphens" do
    @proxy.test_node.should == 'Check meh.'
  end
end

