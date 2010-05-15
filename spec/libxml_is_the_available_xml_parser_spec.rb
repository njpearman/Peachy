require 'spec_helper'

describe Peachy::XmlParserFactory do
  before(:each) do
    Gem.stubs(:available?).with(/libxml/).returns(true)
    Gem.stubs(:available?).with(/nokogiri/).returns(false)
    @factory = Peachy::XmlParserFactory.new
    @factory.stubs(:require).with('libxml').returns(true)
  end

  it "should return LibXML if Nokogiri is not an available gem" do
    parser_type = @factory.load_parser
    parser_type.should == :libxml
  end

  it "should load LibXML if Nokogiri is not an available gem, but LibXML is" do
    first_expectation = Gem.expects(:available?).with(/nokogiri/).returns(false)
    second_expectation = @factory.expects(:require).with('libxml').returns(true)
    parser_type = @factory.load_parser
    first_expectation.satisfied?.should be_true
    second_expectation.satisfied?.should be_true
  end

  it "should not load Nokogiri if Nokogiri is not an available gem" do
    expectation = @factory.expects(:require).with('nokogiri').returns(true).never()
    parser_type = @factory.load_parser
    expectation.satisfied?.should be_true
  end
end

