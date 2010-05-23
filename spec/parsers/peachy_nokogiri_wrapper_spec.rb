require 'spec_helper'

shared_examples_for "all parser wrappers" do
  it "should be able to find the correct matches in the underlying XML" do
    matches = @wrapper.find_matches(Peachy::MethodName.new('child'))
    matches.size.should == 1
    matches[0].name.should == 'child'
    matches[0].should be_a @expected_wrapper_class
  end

  it "should return no matches for a child name that doesn't exist" do
    matches = @wrapper.find_matches(Peachy::MethodName.new('not_a_child'))
    matches.should be_nil
  end

  it "should be able to find the correct attribute matches in the underlying XML" do
    match = @wrapper.find_match_by_attributes(Peachy::MethodName.new('type'))
    match.name.should == 'type'
    match.content.should == 'test'
  end

  it "should return no matches for an attribute name that doesn't exist" do
    matches = @wrapper.find_match_by_attributes(Peachy::MethodName.new('attrbiute'))
    matches.should be_nil
  end

  it "should indicate that an element has children" do
    @wrapper.has_children?.should be_true
  end

  it "should indicate that an element has an attributes" do
    @wrapper.has_attributes?.should be_true
  end

  it "should indicate that an element has both children and an attribute" do
    @wrapper.has_children_and_attributes?.should be_true
  end
end

describe "the Nokogiri parser wrapper class" do
  before(:each) do
    noko = Nokogiri::XML('<root type="test"><child>Name</child></root>')
    @wrapper = Peachy::Parsers::NokogiriWrapper.new((noko/'root')[0])
    @expected_wrapper_class = Peachy::Parsers::NokogiriWrapper
  end

  it_should_behave_like "all parser wrappers"
end

require 'rexml/document'

describe "the REXML parser wrapper class" do
  before(:each) do
    rexml = REXML::Document.new('<root type="test"><child>Name</child></root>')
    @wrapper = Peachy::Parsers::REXMLWrapper.new rexml.root
    @expected_wrapper_class = Peachy::Parsers::REXMLWrapper
  end

  it_should_behave_like "all parser wrappers"
end