require 'spec_helper'

shared_examples_for "all parser wrappers" do
  it "should be able to find the correct matches in the underlying XML" do
    matches = @wrapper.find_matches(Peachy::MethodName.new('child'))
    matches.size.should == 1
    matches[0].name.should == 'child'
    matches[0].content.should == 'Name'
    matches[0].should be_a(@expected_wrapper_class)
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

  it "should return a string representation of the XML" do
    @wrapper.to_s.should == @raw_xml
  end
end
