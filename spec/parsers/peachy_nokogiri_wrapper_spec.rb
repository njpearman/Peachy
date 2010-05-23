require 'spec_helper'

describe "the Nokogiri parser wrapper class" do
  before(:each) do
    noko = Nokogiri::XML('<root><child>Name</child></root>')
    @wrapper = Peachy::Parsers::NokogiriWrapper.new((noko/'root')[0])
  end

  it "should be able to find the correct matches in the underlying XML" do
    matches = @wrapper.find_matches(Peachy::MethodName.new('child'))
    matches.size.should == 1
    matches[0].name.should == 'child'
  end

  it "should return no matches for a child name that doesn't exist" do
    matches = @wrapper.find_matches(Peachy::MethodName.new('not_a_child'))
    matches.should be_nil
  end

  it "should return no matches for an attribute name that doesn't exist" do
    matches = @wrapper.find_match_by_attributes(Peachy::MethodName.new('not_a_child'))
    matches.should be_nil
  end

  it "should indicate that an element has children" do
    @wrapper.has_children?.should be_true
  end

  it "should indicate that an element has no attributes" do
    @wrapper.has_children_and_attributes?.should be_false
    @wrapper.has_attributes?.should be_false
  end
end

