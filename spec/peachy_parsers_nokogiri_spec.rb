require 'spec_helper'

describe "nokogiri wrapper" do
  before(:each) do
    @nokogiri_xml = Nokogiri::XML <<XML
<root>
  <child id="1">Hello</child>
  <second_child  attribute_one="one" attribute_two="two">Contents</second_child>
</root>
XML
    @nokogiri = Peachy::Parsers::NokogiriWrapper.new @nokogiri_xml
  end

  it "should have all of the methods that I expect" do
    @nokogiri.methods.should include 'attribute'
    @nokogiri.methods.should include 'attribute_nodes'
    @nokogiri.methods.should include 'children'
    @nokogiri.methods.should include 'content'
    @nokogiri.methods.should include 'name'
    @nokogiri.methods.should include 'xpath'
  end

  it "should return the expected attributes" do
    @nokogiri.xpath('./root')[0].attribute('anything').should  be_nil
    @nokogiri.xpath('./root/child')[0].attribute('id').should be_a Peachy::Parsers::NokogiriWrapper
    @nokogiri.xpath('./root/child')[0].attribute('id').content.should == '1'
  end

  it "should return the expected attribute_nodes" do
    @nokogiri.xpath('./root/child')[0].attribute_nodes.size.should == 1
    @nokogiri.xpath('./root/second_child')[0].attribute_nodes.size.should == 2
  end

  it "should return the expected children" do
    @nokogiri.xpath('./root')[0].children.size.should == 5
    @nokogiri.xpath('./root/child')[0].children.size.should == 1
  end
  
  it "should return the expected content" do
    @simple_noko = Peachy::Parsers::NokogiriWrapper.new(Nokogiri::XML('<xml>Hello</xml>'))
    @simple_noko.content.should == 'Hello'
    @nokogiri.xpath('./root/child')[0].content.should == 'Hello'
  end

  it "should return the expected name" do
    @nokogiri.name.should == 'document'
  end

  it "should return the expected matches by XPath" do
    @nokogiri.xpath('./xml').size.should == 0
    @nokogiri.xpath('./root').size.should == 1
    @nokogiri.xpath('./root')[0].should be_a Peachy::Parsers::NokogiriWrapper
  end
end

