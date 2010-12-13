require 'spec_helper'

describe "collections with children as arrays" do
  before(:each) do
    xml = <<STR
<xml>
  <list>
    <item>
      <child>one</child>
    </item>
    <item>
      <child>two</child>
    </item>
    <item>
      <child>three</child>
    </item>
  </list>
</xml>
STR
    @peachy_proxy = Peachy::Proxy.new xml
  end

  it "should create an array with the correct size" do
    @peachy_proxy.xml.list.item.size.should == 3
  end

  it "should define a method for the name of the list items" do
    @peachy_proxy.xml.list.item
    @peachy_proxy.xml.list.methods.map{|m| m.to_s}.should include('item')
  end

  it "should create the children as expected" do
    @peachy_proxy.xml.list.item[0].child.value.should == "one"
    @peachy_proxy.xml.list.item[1].child.value.should == "two"
    @peachy_proxy.xml.list.item[2].child.value.should == "three"
  end
end

