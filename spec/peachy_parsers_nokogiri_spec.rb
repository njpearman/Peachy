require 'spec_helper'

describe "nokogiri wrapper" do
  before(:each) do
    @nokogiri_xml = Nokogiri::XML <<XML
<root identity="1234" category="awesomeness">
  <child id="1">Hello</child>
  <second_child  attribute_one="one" attribute_two="two">Contents</second_child>
</root>
XML
    @nokogiri = Peachy::Parsers::NokogiriWrapper.new @nokogiri_xml
  end

  it "should have all of the methods that I expect" do
    @nokogiri.methods.should include 'content'
    @nokogiri.methods.should include 'name'
  end

  it "should return the expected content" do
    @simple_noko = Peachy::Parsers::NokogiriWrapper.new(Nokogiri::XML('<xml>Hello</xml>'))
    @simple_noko.content.should == 'Hello'
  end

  it "should return the expected name" do
    @nokogiri.name.should == 'document'
  end
end

