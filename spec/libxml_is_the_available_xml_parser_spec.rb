require 'spec_helper'

describe Peachy::XmlParserFactory do
  before(:each) do
    @factory = Peachy::XmlParserFactory.new
  end

  it "should return LibXML if Nokogiri is not an available gem" do
    Gem.stubs(:available?).with('nokogiri').returns(false)
    Gem.stubs(:available?).with('libxml-ruby').returns(true)
    parser_type = @factory.load_parser
    parser_type.should == :libxml
  end

  it "should load LibXML if Nokogiri is not an available gem, but LibXML is" do
    Gem.stubs(:available?).with('nokogiri').returns(false)
    Gem.stubs(:available?).with('libxml-ruby').returns(true)
    expectation = @factory.expects(:require).with('libxml').returns(true)
    parser_type = @factory.load_parser
    expectation.satisfied?.should == true
  end

  it "should not load Nokogiri if Nokogiri is not an available gem" do
    Gem.stubs(:available?).with('nokogiri').returns(false)
    Gem.stubs(:available?).with('libxml-ruby').returns(true)
    @factory.stubs(:require).with('libxml').returns(true)
    expectation = @factory.expects(:require).with('nokogiri').returns(true).never()
    parser_type = @factory.load_parser
    expectation.satisfied?.should == true
  end

  it "should blow up if no XML parsing library is available" do
    Gem.stubs(:available?).returns(false)
    lambda { parser_type = @factory.load_parser }.should raise_error NoXmlParserAvailable
  end
end

