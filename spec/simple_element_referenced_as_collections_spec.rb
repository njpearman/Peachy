describe "a simple element referenced as the first part of a collection" do
  before(:each) do
    xml = <<XML
<xml>
  <list>
    <item>Hello</item>
  </list>
</xml>
XML
    @proxy = Peachy::Proxy.new xml
  end

  it "should infer that the element matches the first index of an array" do
    @proxy.xml.list.item[0].value.should == 'Hello'
  end

  it "should quack like an array" do
    @proxy.xml.list.item[0]

    element_as_array = @proxy.xml.list.item
    element_as_array.any?.should be_true
    element_as_array.empty?.should be_false
    element_as_array.size.should == 1
    (element_as_array.map {|item| item.value }).should == ['Hello']
    element_as_array[0].value.should == 'Hello'
  end

  it "should raise an error if the element value has already been accessed as an only child" do
    expected_message = <<MSG
The 'item' node has already been accessed as a single child, but you are now trying to use it as a collection.
Do not try to access Peachy::Proxies in a mixed manner in your implementation.
MSG
    @proxy.xml.list.item.value
    lambda { @proxy.xml.list.item[0] }.should raise_error(AlreadyAnOnlyChild, expected_message)
  end
end
