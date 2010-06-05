require 'spec_helper'
require File.join(File.dirname(__FILE__), 'all_parser_wrappers_spec')

# this is to ignore this spec if the nokogiri gem is not available
if Gem.available? 'nokogiri'
  require 'nokogiri'
  describe "a Peachy::Parsers::NokogiriWrapper" do
    before(:each) do
      @raw_xml = "<root type=\"test\">\n  <child>Name</child>\n</root>"
      noko = Nokogiri::XML(@raw_xml)
      @wrapper = Peachy::Parsers::NokogiriWrapper.new((noko/'root')[0])
      @expected_wrapper_class = Peachy::Parsers::NokogiriWrapper
    end

    it_should_behave_like "all parser wrappers"
  end
end
