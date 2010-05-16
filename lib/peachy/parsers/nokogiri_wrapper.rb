module Peachy
  module Parsers
    class NokogiriWrapper
      def initialize nokogiri
        @nokogiri = nokogiri
      end

      def attribute attribute_name
        noko = @nokogiri.attribute(attribute_name)
        noko.nil?? nil : NokogiriWrapper.new(noko)
      end

      def attribute_nodes
        @nokogiri.attribute_nodes.map {|attribute| attribute.content }
      end

      def children
        @nokogiri.children.map {|child| NokogiriWrapper.new(child) if child.kind_of? Nokogiri::XML::Element }
      end

      def content
        @nokogiri.content
      end

      def name
        @nokogiri.name
      end

      def xpath xpath
        @nokogiri.xpath(xpath).map{|noko_node| NokogiriWrapper.new(noko_node) }
      end
    end
  end
end