describe "a simple XML collection should be interpretted as an array" do
  before(:each) do
    xml = "<xml><stuff><item>first</item><item>second</item><item>third</item></stuff></xml>"
    @proxy = Peachy::Proxy.new :xml => xml
  end

  it "should set the correct sized array for a collection" do
    @proxy.xml.stuff.item.size.should == 3
  end

  it "should define a method for the item list name" do
    @proxy.xml.stuff.item
    @proxy.xml.stuff.methods.should include 'item'
  end

  it "should set each array item to the content for the list item" do
    @proxy.xml.stuff.item[0].should == 'first'
    @proxy.xml.stuff.item[1].should == 'second'
    @proxy.xml.stuff.item[2].should == 'third'
  end
end

