describe "nodes with multiple children should be handled correctly" do
  before(:each) do
    @peachy_proxy = Peachy::Proxy.new :xml => '<testnode><child>Check meh.</child><second_child><ancestor>Check meh two times.</ancestor></second_child></testnode>'
    @node_to_test = @peachy_proxy.testnode
  end

  it "should recurse the Proxy to children so that a child will have the correct value" do
    @node_to_test.child.should == "Check meh."
  end

  it "should define a method with the child name on the proxy" do
    @node_to_test.child
    @node_to_test.second_child
    @node_to_test.methods.should include 'child'
    @node_to_test.methods.should include 'second_child'
  end

  it "should recurse the Proxy to ancestors so that a child will have the correct value" do
    @node_to_test.second_child.ancestor.should == "Check meh two times."
  end
end

