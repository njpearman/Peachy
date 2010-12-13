require 'spec_helper'
require 'rexml/document'

describe "the REXML parser wrapper class" do
  before(:each) do
    @raw_xml = "<root type='test'>\n  <child>Name</child>\n</root>"
    rexml = REXML::Document.new(@raw_xml)
    @wrapper = Peachy::Parsers::REXMLWrapper.new rexml.root
    @expected_wrapper_class = Peachy::Parsers::REXMLWrapper
  end

  it_should_behave_like 'all parser wrappers in Peachy'
end
