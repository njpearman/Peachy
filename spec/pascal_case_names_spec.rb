describe "interpreting element and attribute names that are defined in PascalCase" do
  before(:each) do
    @proxy = Peachy::Proxy.new :xml => '<Root><TestNode>Check meh.</TestNode><SecondNode Id="2" RecordLabel="Wall of Sound">Check meh, too.</SecondNode></Root>'
  end

  it "should match a method to an element by pascal case" do
    @proxy.root.test_node.should == 'Check meh.'
  end

  it "should define a method from a pascal cased element name" do
    @proxy.root.test_node.should == 'Check meh.'
    @proxy.root.methods.should include 'test_node'
  end

  it "should match a method to an attribute by pascal case" do
    @proxy.root.second_node.record_label.should == "Wall of Sound"
  end

  it "should define a method from pascal cased attribute name" do
    @proxy.root.second_node.record_label
    @proxy.root.second_node.methods.should include 'record_label'
  end
end

