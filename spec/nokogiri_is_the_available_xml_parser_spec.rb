require 'spec_helper'


# this is to ignore this spec if the nokogiri gem is not available
if Gem.available? 'nokogiri'
  require 'nokogiri'

  describe "nokogiri is the available XML parser" do
    before(:each) do
      @factory = Peachy::Parsers::ParserFactory.new
      expectation = @factory.stubs(:require).with('nokogiri').returns(true)
    end

    it "should indicate that the parser has been loaded" do
      @factory.load_parser.should be_true
    end

    it "should check whether Nokogiri is available" do
      expectation = Gem.expects(:available?).with('nokogiri').returns(true)
      parser_type = @factory.load_parser
      expectation.satisfied?.should be_true
    end

    it "should load Nokogiri" do
      expectation = @factory.expects(:require).with('nokogiri').returns(true)
      parser_type = @factory.load_parser
      expectation.satisfied?.should be_true
    end

    it "should not load REXML" do
      expectation = @factory.expects(:require).with('rexml/document').never.returns(true)
      parser_type = @factory.load_parser
      expectation.satisfied?.should be_true
    end

    it "should enable a way to a new NokogiriWrapper" do
      @factory.load_parser
      @factory.methods.should include('make_from')
    end

    it "should create a NokogiriWrapper from xml" do
      @factory.load_parser
      wrapper = @factory.make_from '<thing>Stuff</thing>'
      wrapper.should be_a(Peachy::Parsers::NokogiriWrapper)
      wrapper.content.should == 'Stuff'
    end
  end
end