require 'spec_helper'

describe "nokogiri is the available XML parser" do
  before(:each) do
    @factory = Peachy::XmlParserFactory.new
  end

  it "should check whether Nokogiri is available" do
    expectation = Gem.expects(:available?).with('nokogiri').returns(true)
    parser_type = @factory.load_parser
    expectation.satisfied?.should be_true
  end
  
  it "should return Nokogiri if Nokogiri is an available gem" do
    parser_type = @factory.load_parser
    parser_type.should == :nokogiri
  end

  it "should load Nokogiri if Nokogiri is an available gem" do
    expectation = @factory.expects(:require).with('nokogiri').returns(true)
    parser_type = @factory.load_parser
    expectation.satisfied?.should be_true
  end
end

