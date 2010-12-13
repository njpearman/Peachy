require 'spec_helper'
require 'rexml/document'

describe "only REXML is available" do
  before(:each) do
    @factory = Peachy::Parsers::ParserFactory.new
    @factory.stubs(:require).with('rexml/document').returns(true)
    Gem.stubs(:available?).with('nokogiri').returns(false)
    Gem.stubs(:available?).with('rexml/document').returns(true)
  end

  it "should indicate that the parser has been loaded" do
    @factory.load_parser.should be_true
  end

  it "should load REXML" do
    expectation = @factory.expects(:require).with('rexml/document').returns(true)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end

  it "should check whether other XML parsers are available" do
    expectation = Gem.expects(:available?).with('nokogiri').returns(false)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end

  it "should not load any other XML parsers" do
    expectation = @factory.expects(:require).with('nokogiri').never.returns(false)
    @factory.load_parser
    expectation.satisfied?.should be_true
  end

  it "should enable a way to a new REXMLWrapper" do
    @factory.load_parser
    @factory.methods.map{|m| m.to_s}.should include('make_from')
  end

  it "should create a REXMLWrapper from xml" do
    @factory.load_parser
    wrapper = @factory.make_from '<thing>Stuff</thing>'
    wrapper.should be_a(Peachy::Parsers::REXMLWrapper)
    wrapper.name.should == ''
  end
end

