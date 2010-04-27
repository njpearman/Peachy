describe "interpretting element and attribute names that are defined camel case" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<root><TestNode>Check meh.</TestNode><SecondNode id="2" RecordLabel="Wall of Sound">Check meh, too.</SecondNode></root>'
  end

  it "should match a method to an element by camel case" do
    @proxy.root.test_node.should == 'Check meh.'
  end

  it "should define a method from a camel cased element name" do
    @proxy.root.test_node.should == 'Check meh.'
    @proxy.root.methods.should include 'test_node'
  end

  it "should match a method to an attribute by camel case" do
    @proxy.root.second_node.record_label.should == "Wall of Sound"
  end

  it "should define a method from camel cased attribute name" do
    @proxy.root.second_node.record_label
    @proxy.root.second_node.methods.should include 'record_label'
  end
end

