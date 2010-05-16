require 'spec_helper'
module Peachy
  module Parsers
    class Nokogiri
      def initialize nokogiri
        @nokogiri = nokogiri
      end

      def name
        @nokogiri.name
      end

      def attribute attribute_name
        noko = @nokogiri.attribute(attribute_name)
        noko.nil?? nil : Nokogiri.new(noko)
      end

      def attribute_nodes

      end

      def content
        @nokogiri.content
      end

      def xpath xpath
        @nokogiri.xpath(xpath).map{|noko_node| Nokogiri.new(noko_node) }
      end

      def children
        
      end
    end
  end
end
describe "nokogiri wrapper" do
  before(:each) do
    @nokogiri_xml = Nokogiri::XML('<root><child id="1">Hello</child></root>')
    @nokogiri = Peachy::Parsers::Nokogiri.new @nokogiri_xml
  end

  it "should have all of the methods that I expect" do
    @nokogiri.methods.include?('name').should be_true
    @nokogiri.methods.include?('attribute').should be_true
    @nokogiri.methods.include?('attribute_nodes').should be_true
    @nokogiri.methods.include?('content').should be_true
    @nokogiri.methods.include?('xpath').should be_true
    @nokogiri.methods.include?('children').should be_true
  end

  it "should return the expected name" do
    @nokogiri.name.should == 'document'
  end

  it "should return the expected content" do
    @simple_noko = Peachy::Parsers::Nokogiri.new(Nokogiri::XML('<xml>Hello</xml>'))
    @simple_noko.content.should == 'Hello'
    @nokogiri.content.should == 'Hello'
  end

  it "should return the expected matches by XPath" do
    @nokogiri.xpath('./xml').size.should == 0
    @nokogiri.xpath('./root').size.should == 1
    @nokogiri.xpath('./root')[0].should be_a Peachy::Parsers::Nokogiri
  end

  it "should return the expected attributes" do
    @nokogiri.xpath('./root')[0].attribute('anything').should  be_nil
    @nokogiri.xpath('./root/child')[0].attribute('id').should be_a Peachy::Parsers::Nokogiri
    @nokogiri.xpath('./root/child')[0].attribute('id').content.should == '1'
  end
end

