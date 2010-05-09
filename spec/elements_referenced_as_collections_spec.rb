describe "an element referenced as first part of a collection" do
  before(:each) do
    xml = <<XML
<xml>
  <list>
    <item>
      <child>one</child>
    </item>
  </list>
</xml>
XML
    @proxy = Peachy::Proxy.new xml
  end

  it "should infer that the element matches the first index of an array" do
    @proxy.xml.list.item[0].child.should == 'one'
  end

  it "should quack like an array" do
    @proxy.xml.list.item[0]

    element_as_array = @proxy.xml.list.item
    element_as_array.any?.should be_true
    element_as_array.one?.should be_true
    element_as_array.empty?.should be_false
    element_as_array.size.should == 1
    element_as_array[0].child.should == 'one'
  end

  it "should raise an error if the element has already been accessed as a single child" do
    @proxy.xml.list.item.child
    lambda { @proxy.xml.list.item[0] }.should raise_error AlreadyASingleChild, <<MSG
The 'item' node has already been accessed as a single child, but you are now trying to use it as a collection.
Do not try to access Peachy::Proxies in a mixed manner in your implementation.
MSG
  end
end
