require 'spec_helper'

describe "a REXMLAttributeWrapper" do
  before(:each) do
    @attribute_name = 'name'
    @attribute_value = 'value'
    @wrapper = Peachy::Parsers::REXMLAttributeWrapper.new [@attribute_name, @attribute_value]
  end

  it "should return the string contents of the attribute" do
    @wrapper.to_s.should == @attribute_value
  end
end

