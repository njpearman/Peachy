describe "attributes on a parent node" do
  before(:each) do
    @proxy = Peachy::Proxy.new '<root><test_node name="Test"><child>Check meh.</child><test_node></root>'
  end

  it "should return the child when accessing it by name" do
    @proxy.root.test_node.child.should == 'Check meh.'
  end

  it "should return the parent attribute by name" do
    @proxy.root.test_node.name.should == 'Test'
  end

  it "should define the attribute name as a method" do
    @proxy.root.test_node.name
    @proxy.root.test_node.methods.should include 'name'
  end
end