describe "interpretting element names that contain hyphens" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<test-node>Check meh.</test-node>')
    @proxy = Peachy::Proxy.new @nokogiri_for_test
  end

  it "should try to match a method to a node with hyphens" do
    @proxy.test_node.should == 'Check meh.'
  end
end

