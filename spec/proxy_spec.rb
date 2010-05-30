require 'spec_helper'

describe "stringifying a Proxy" do
  it "should return the stringified underlying parser wrapper" do
    expected_string = "<some><xml>XML!!</xml></some>"
    stub_wrapper = mock()
    stub_wrapper.stubs(:to_s).returns(expected_string)
    stub_wrapper.stubs(:kind_of?).with(String).returns(false)
    stub_wrapper.stubs(:kind_of?).with(Peachy::Parsers::ParserWrapper).returns(true)
    proxy = Peachy::Proxy.new stub_wrapper

    proxy.to_s.should == expected_string
  end

  it "should return the XML that is passed in to the consructor" do
    expected_string = "<some><xml>XML!!</xml></some>"
    proxy = Peachy::Proxy.new expected_string
    proxy.to_s.should == expected_string
  end
end

