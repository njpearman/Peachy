require 'spec_helper'

describe "only REXML is available" do
  before(:each) do
    @factory = Peachy::Parsers::ParserFactory.new
    @factory.stubs(:require).with('rexml/document').returns(true)
    Gem.stubs(:available?).with(/nokogiri/).returns(false)
  end

  it "should return REXML if no other XML parser is available" do
    parser = @factory.load_parser
    parser.should == :rexml
  end

  it "should load REXML" do
    expectation = @factory.expects(:require).with('rexml/document').returns(true)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end

  it "should check whether other XML parsers are available" do
    expectation = Gem.expects(:available?).with(/nokogiri/).returns(false)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end

  it "should not load any other XML parsers" do
    expectation = @factory.expects(:require).with('nokogiri').never.returns(false)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end
end

