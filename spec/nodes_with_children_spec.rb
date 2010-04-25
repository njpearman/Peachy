describe "nodes with children should be handled correctly" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<testnode><child>Check meh.</child><second_child><ancestor>Check meh two times.</ancestor></second_child></testnode>')
    @peachy_proxy = Peachy::Proxy.new @nokogiri_for_test
    @node_to_test = @peachy_proxy.testnode
  end

  it "should define a method for the child node" do
    @node_to_test.child.should_not be_nil
  end

  it "should recurse the Proxy to children so that a child will have the correct value" do
    @node_to_test.child.should == "Check meh."
  end

  it "should recurse the Proxy to ancestors so that a child will have the correct value" do
    @node_to_test.second_child.ancestor.should == "Check meh two times."
  end
end

