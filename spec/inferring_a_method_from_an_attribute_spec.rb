describe "inferring a method from an attribute" do
  before(:each) do
    @nokogiri_for_test = Nokogiri::XML('<test-node id="1" another="yellow">Check meh.</test-node>')
    @proxy = Peachy::Proxy.new @nokogiri_for_test
  end

  it "should be able to access node contents by 'value'" do
    @proxy.test_node.value.should == 'Check meh.'
  end

  it "should be able to generate a method representing an attribute" do
    @proxy.test_node.id.should == '1'
  end
end

