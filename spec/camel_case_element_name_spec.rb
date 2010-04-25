describe "interpretting element names that are defined camel case" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<TestNode>Check meh.</TestNode>')
    @proxy = Peachy::Proxy.new @nokogiri_for_test
  end

  it "should try to match a method to a node by camel case" do
    @proxy.test_node.should == 'Check meh.'
  end
end

